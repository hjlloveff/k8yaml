'''
Created on 2017/08/18

@author: Ken Chang
'''
import os
import sys
import yaml
import base64
import requests
import logging
from code_utils.ClusterCliCmds.Exceptions import NotIndicatedImageException
from shutil import copytree, rmtree, copyfile
from salt.client import LocalClient

logger = logging.getLogger(__name__)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
ch.setFormatter(formatter)

logger.addHandler(ch)

dir_path = os.path.dirname(os.path.realpath(__file__))

def load_yaml(file_path):
    with open(file_path) as stream:
        return yaml.load(stream)
    
def move_salt_files(configs, customer):
    salt_path = "%s/botconfig" % configs['saltstack']['state_path']
    source_path = configs['saltstack']['sls_path']
    
    # remove old sls files
    if os.path.exists(salt_path):
        rmtree(salt_path)
    
    # copy sls files to salt folder
    copytree('%s/botconfig' % source_path , salt_path)
    
    # put pillar file
    copyfile('%s/../../customer/%s/default.sls' % (dir_path, customer), '%s/default.sls' % configs['saltstack']['pillar_path'])

def check_module_is_up(target, name):
    client = LocalClient()
    
    docker_cmd = 'docker ps | grep -e " %s$"' % name 
    results = client.cmd(target, 'cmd.run', [docker_cmd])
    
    is_up = False
    for target in results:
        result = results[target]
        
        if 'Up ' in result:
            is_up = True
            break
        
    return is_up

def remove_container(target, name):
    client = LocalClient()
    
    docker_cmd = 'docker rm -f %s' % name
    results = client.cmd(target, 'cmd.run', [docker_cmd])
    
    return results

def get_host_to_moudle_mapping(services_to_hosts_map):
    
    def add_modules_to_hosts(units, host_to_module, type):
        for name in units:
            target_hosts = units[name]['deploy_to']
            for target_host in target_hosts:
                if not host_to_module.has_key(target_host):
                    host_to_module[target_host] = {}
                    
                if not host_to_module[target_host].has_key(type):
                    host_to_module[target_host][type] = []
                    
                host_to_module[target_host][type].append(name)
        
        return host_to_module
    
    host_to_module = {}
    for service_unit_name in services_to_hosts_map:
        service_unit = services_to_hosts_map[service_unit_name]
        
        if 'infrastructures' in service_unit:
            host_to_module = add_modules_to_hosts(service_unit['infrastructures'], host_to_module, 'infrastructures')
        
        if 'modules' in service_unit:
            host_to_module = add_modules_to_hosts(service_unit['modules'], host_to_module, 'modules')
        
    return host_to_module

def get_hosts_of_target(services_to_hosts_map, target, target_type):
    for service_unit_name in services_to_hosts_map:
        service_unit = services_to_hosts_map[service_unit_name]
        if target_type in service_unit and target in service_unit[target_type]:
            host_list = service_unit[target_type][target]['deploy_to']
            return host_list

def compose_docker_cmd(container_info):
        parser_obj = ContainerInfoParser(container_info)
        
        img = parser_obj.parse_container_img()
        
        if img is None:
            raise NotIndicatedImageException()
            return 
        
        container_name = parser_obj.parse_container_name()
        
        cmd = 'docker run -d'
        if container_name is not None:
            cmd += ' --name %s' % container_name
        
        ports_args = parser_obj.parse_publish_ports()
        if ports_args is not None:
            cmd += ' %s' % ports_args
            
#         resoruces_args = parser_obj.parse_resource()
#         if resoruces_args is not None:
#             cmd += ' %s' % resoruces_args
            
        volumes_args = parser_obj.parse_volumes()
        if volumes_args is not None:
            cmd += ' %s' % volumes_args
            
        envs_args = parser_obj.parse_env()
        if envs_args is not None:
            cmd += ' %s' % envs_args
            
        log_opt_args = parser_obj.parse_log_opt()
        if log_opt_args is not None:
            cmd += ' %s' % log_opt_args
        
        restart_args = parser_obj.parse_restart_policy()
        if restart_args is not None:
            cmd += ' %s' % restart_args
        
        cmd += ' %s' % img
        
        return cmd  
        pass

class ContainerInfoParser():
    def __init__(self, container_info):
        self.container_info = container_info
        
    def parse_publish_ports(self):
        if 'ports' in self.container_info:
            result_str = ''
            for port_str in self.container_info['ports']:
                result_str += ' -p %s' % port_str
            return result_str
        
        else:
            return None
        
    def parse_resource(self):
        if 'resources' in self.container_info:
            result_str = ''
            if 'limits' in self.container_info['resources']:
                limits = self.container_info['resources']['limits']
                if 'cpus' in limits:
                    result_str += ' --cpus=%s' % limits['cpus']
                if 'memory' in limits:
                    result_str += ' --memory=%s' % limits['memory']
                    
            if 'reservations' in self.container_info['resources']:
                reservations = self.container_info['resources']['reservations']
                if 'cpus' in reservations:
                    result_str += ' --cpus=%s' % reservations['cpus']
                if 'memory' in reservations:
                    result_str += ' --memory-reservation=%s' % reservations['memory']
            
            return result_str
                
        else:
            return None
    
    def parse_volumes(self):
        if 'volumes' in self.container_info:
            result_str = ''
            for volume_str in self.container_info['volumes']:
                # ignore if volume is $RUNROOT/lib:/usr/src/emotibotcontroller/lib
                if "/usr/src/emotibotcontroller/lib" in volume_str:
                    continue
                
                result_str += ' -v %s' % volume_str
            return result_str
        else:
            return None
        
    def parse_env(self):
        if 'environments' in self.container_info:
            result_str = ''
            for env_str in self.container_info['environments']:
                if '"' in env_str:
                    result_str += ' -e %s' % env_str
                else:
                    result_str += ' -e "%s"' % env_str
                    
            if self.container_info['container_name'] == 'rewrite':
                result_str += ' -e %s' % 'SYSTEM_TIME_ZONE=Asia/Shanghai'
                result_str += ' -e %s' % 'REWRITE_HOME_DIR=/usr/src/app'
                
            return result_str
        else:
            return None
        
    def parse_container_name(self):
        if 'container_name' in self.container_info:
            return self.container_info['container_name']
        else:
            return None
        
    def parse_container_img(self):
        if 'image' in self.container_info and 'tag' in self.container_info:
            return '%s:%s' %(self.container_info['image'], self.container_info['tag'])
        else:
            return None
        
    def parse_log_opt(self):
        result_str = ''
        if 'options' in self.container_info:
            options = self.container_info['options']
            
            if 'max-file' in options:
                result_str += ' --log-opt max-file=%s ' % options['max-file']
                
            if 'max-size' in options:
                result_str += ' --log-opt max-size=%s ' % options['max-size']
            
            return result_str
        else:
            return None
        
    def parse_restart_policy(self):
        result_str = ''
        if 'restart' in self.container_info:
            result_str += ' --restart %s ' % self.container_info['restart']
            return result_str
        else:
            return None

CONSUL_KV_API = 'v1/kv'
DC_CONSUL_KEY = 'idc/dc/vipshop'
DC_QAONLY_KEY = 'service_vipFAQonly'

def send_faq_config(host, key, data):
    url = os.path.join(host, CONSUL_KV_API, key)
    data_ = ''
    for k in data.keys():
        if data_:
            data_ = '%s\n' % data_
        data_ = '%s%s=%s' % (data_, k, data[k])
    # print 'url: %s, data: %s' % (url, data_)
    try:
        requests.put(url, data=data_, timeout=(5, 5))
    except Exception as exp:
        logger.critical('put %s to %s failed.(%s)' % (data, url, exp))
        sys.exit(1)

def get_faq_data(host=None, key=None):
    def _default_node():
        return {
            'service_Faq': 'true',
            'service_Dg': 'false',
            'service_Ibb': 'false',
            'service_Memory': 'false'
        }

    url = os.path.join(host, CONSUL_KV_API, key)
    # print 'url: %s' % url
    try:
        resp = requests.get(url, timeout=(5, 5))
    except Exception as exp:
        logger.critical('get value failed: %s(%s)' % (url, exp))
        sys.exit(1)

    try:
        resp.raise_for_status()
    except Exception as exp:
        logger.critical('get %s failed.(%s)' % (key, resp.status_code))
        sys.exit(1)

    resp_list = list()
    try:
        resp_list = resp.json()
    except Exception as exp:
        logger.critical('convert %s to list failed.(%s)' % (resp.content, exp))
        sys.exit(1)

    assert isinstance(resp_list, list)
    try:
        node = resp_list.pop(0)
        value = node.get('Value', '')
        if not value:
            return _default_node()
        b64_value = base64.b64decode(value)
        datas = b64_value.split('\n')
        # print datas
        d = dict()
        for data in datas:
            pairs = data.split('=')
            d[pairs[0]] = pairs[1]
        return d

    except IndexError:
        return _default_node()
    
def get_url_and_data(config):
    consul_config = config['consul']
    
    url = 'http://%s:%s' % (consul_config['host'], consul_config['port'])
    data = get_faq_data(url, consul_config['dckey'])
        
    return url, data

def is_faq_only(data):
    only = False
    for k in data.keys():
        if k == DC_QAONLY_KEY and 'true' in data[k]:
            only = True
            break
        
    return only