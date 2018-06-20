import re
import socket
from service_conf import conf
from code_utils.Exceptions import NotAllowedHostExceptoin, ServiceNotExistException, EnvNotExistException
from distutils.command.config import config

def check_host(enabled_hosts, host, ignore=False):
    if host in enabled_hosts or '*' in enabled_hosts or ignore:
        return True
    else:
        raise NotAllowedHostExceptoin()
    pass

def query_service_config(service_name, env):
    services = conf['services']
    
    service_exist = False
    config = {}
    for service in services:
        if not service['service_name'] == service_name:
            continue
           
        service_exist = True     
        env_exist = False
        for service_env in service['envs']:
            if not env == service_env['name']:
                continue
                
            env_exist = True
            targets = ['tag', 'host', 'path', 'create', 'update', 'prefix', 'run']
            for target in targets:
                if target in service_env:
                    config[target] = service_env[target]
                if target in service:
                    config[target] = service[target]
            
        if not env_exist:
            raise EnvNotExistException()
            
    if not service_exist:
        raise ServiceNotExistException()
                    
    return config
                    
    pass

def get_service_env_variables(file_path, service_prefix):
    envs = []
    with open(file_path, 'r') as f:
        for line in f:
            match = re.match("%s_.+" % (service_prefix), line)
            if match is not None:
                envs.append(match.group())
    
    return envs
    pass

def get_host_name():
    hostname = socket.gethostname().split('.')[0]
    return hostname