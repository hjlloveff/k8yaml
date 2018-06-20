import os
import logging
from utils import load_yaml, move_salt_files, check_module_is_up, ContainerInfoParser, compose_docker_cmd,\
remove_container, get_host_to_moudle_mapping, get_url_and_data, is_faq_only, send_faq_config, DC_QAONLY_KEY
from Exceptions import NoSuchInfrastructureException, InfraIsNotUpException, ChatModuleIsNotUpException
from salt.client import LocalClient
from code_utils.ClusterCliCmds.utils import get_hosts_of_target

logger = logging.getLogger(__name__)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
ch.setFormatter(formatter)

logger.addHandler(ch)

dir_path = os.path.dirname(os.path.realpath(__file__))
supported_infra = {
            'consul-leader': 'botconfig.vendors.consul.leader',
            'consul-follower': 'botconfig.vendors.consul.follower',
            'solr' : 'botconfig.vendors.solr',
            'arangodb': 'botconfig.vendors.arangodb',
            'redis': 'botconfig.vendors.redis',
            'mysql': 'botconfig.vendors.mysql',
            'mongo': 'botconfig.vendors.mongo',
            'filebeat': 'botconfig.vendors.filebeat',
            'logstash': 'botconfig.vendors.logstash',
            'grafana': 'botconfig.vendors.grafana',
            'graphite': 'botconfig.vendors.graphite',
            'statsd': 'botconfig.vendors.statsd',
            'image-server':'botconfig.vendors.imageServer'
        }

def restart_infra_impl(infra_name, target_server):
    # check if infra is supported
    if infra_name not in supported_infra:
        raise NoSuchInfrastructureException('',1)
    
    logger.info('restart infra:%s on %s' % (infra_name, target_server))
    
    sls_arg = supported_infra[infra_name]
    # send saltstack cmd to restart infra
    client = LocalClient()
    client.cmd(target_server, 'state.apply', [sls_arg])
    
    # check if the infrastructure is up
    if not check_module_is_up(target_server, infra_name):
        raise InfraIsNotUpException(infra_name)
    
    logger.info('restart infra:%s on %s success' % (infra_name, target_server))

def restart_module_impl(module_name, target_server, settings):
    module_settings = settings[module_name]
    # container info 
    container_info = ContainerInfoParser(module_settings)
    container_name = container_info.parse_container_name()
    
    # remove old container
    remove_container(target_server, container_name)
    
    logger.info('restart module:%s on %s' % (module_name, target_server))
    
    # send docker cmd
    docker_cmd = compose_docker_cmd(module_settings)
    client = LocalClient()
    client.cmd(target_server, 'cmd.run', [docker_cmd])
    
    # check if the module is up
    if not check_module_is_up(target_server, container_name):
        raise ChatModuleIsNotUpException(module_name)
    
    logger.info('restart module:%s on %s success' % (module_name, target_server))

def deploy_service_unit(service_unit, service_settings):
    # deploy infrastructures
    if 'infrastructures' in service_unit:
        infras = service_unit['infrastructures']
        for infra_name in infras:
            infra = infras[infra_name]
            for target_server in infra['deploy_to']:
                restart_infra_impl(infra_name, target_server)
                
    # deploy chat modules
    if 'modules' in service_unit:
        modules = service_unit['modules']
        for module_name in modules:
            module = modules[module_name]
            for target_server in module['deploy_to']:
                restart_module_impl(module_name, target_server, service_settings)

def deploy_all(customer):
    '''
    Implementation of flow of deploy all service unit
    '''
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    # load deploy config from config.yaml
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    
    # load service unit config from services.yaml
    service_units_config = load_yaml('%s/services.yaml' % customer_path)
    
    # load settings of chat modules
    service_version = deploy_config['update']['version']
    services_settings = load_yaml('%s/%s.yaml' % (customer_path, service_version))
    
    # update sls files
    move_salt_files(deploy_config, customer)
    
    # deploy service unit one by one
    for service_unit_name in service_units_config:
        service_unit = service_units_config[service_unit_name]
        deploy_service_unit(service_unit, services_settings)

def restart_all(customer, target_server):
    '''
    restart all infrastructure and chat modules on the target server
    '''
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    # load configs from config.yaml
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    service_config = load_yaml('%s/%s.yaml' % (customer_path, deploy_config['update']['version']))
    modules_to_hosts_config = load_yaml('%s/services.yaml' % customer_path)
    
    # get infrastructure and modules running on the server
    infra_and_modules = get_host_to_moudle_mapping(modules_to_hosts_config)
    infras = infra_and_modules[target_server]['infrastructures']
    modules = infra_and_modules[target_server]['modules']
    
    # restart infrastructure one by one
    for infra in infras:
        restart_infra_impl(infra, target_server) 
    
    # restart modules one by one
    for module in modules:
        restart_module_impl(module, target_server, service_config)

def restart_infrastructure(customer, target_infra, target_server=None):
    '''
    restart infrastructure, if target_server is given, restart the infrastructure on target server
    '''
    # restart infra
    if target_server is None:
         # load config
        customer_path = '%s/../../customer/%s/' % (dir_path, customer)
        modules_to_hosts_config = load_yaml('%s/services.yaml' % customer_path)
        target_hosts = get_hosts_of_target(modules_to_hosts_config, target_infra, 'infrastructures')
        
        for host in target_hosts:
            restart_infra_impl(target_infra, host)
    else:
        restart_infra_impl(target_infra, target_server)

def restart_module(customer, target_module, target_server=None):
    '''
    restart a module, if targer_server is given, restart the module on target server
    '''
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    settings = load_yaml('%s/%s.yaml' % (customer_path, deploy_config['update']['version']))
    
    if target_server is None:
        modules_to_hosts_config = load_yaml('%s/services.yaml' % customer_path)
        target_hosts = get_hosts_of_target(modules_to_hosts_config, target_module, 'modules')
        
        for host in target_hosts:
            restart_module_impl(target_module, host, settings)
    else:
        restart_module_impl(target_module, target_server, settings)


def update_modules(customer, target_server):
    '''
    update modules on the target server, but not infrastructure
    '''
    # load config
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    settings = load_yaml('%s/%s.yaml' % (customer_path, deploy_config['update']['version']))
    modules_to_hosts_config = load_yaml('%s/services.yaml' % customer_path)
    infra_and_modules = get_host_to_moudle_mapping(modules_to_hosts_config)
    modules = infra_and_modules[target_server]['modules']
    
    # update sls files
    move_salt_files(deploy_config, customer)
    
    # update modules
    for module in modules:
        restart_module_impl(module, target_server, settings)
        

def update_infra(customer, target_infra, target_server=None):
    # load config
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    
    # update sls files
    move_salt_files(deploy_config, customer)
    
    # restart
    if target_server is None:
        modules_to_hosts_config = load_yaml('%s/services.yaml' % customer_path)
        target_hosts = get_hosts_of_target(modules_to_hosts_config, target_infra, 'infrastructures')
        
        for host in target_hosts:
            restart_infra_impl(target_infra, host)
    else:
        restart_infra_impl(target_infra, target_server)

def rollback_modules(customer, target_server):
    '''
    rollback modules on target server
    '''
    # load config
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    rollback_settings = load_yaml('%s/%s.yaml' % (customer_path, deploy_config['rollback']['version']))
    
    # get modules on the target server
    modules_to_hosts_config = load_yaml('%s/services.yaml' % customer_path)
    infra_and_modules = get_host_to_moudle_mapping(modules_to_hosts_config)
    modules = infra_and_modules[target_server]['modules']
    
    # rollback back each module
    for module in modules:
        restart_module_impl(module, target_server, rollback_settings)
    

def rollback_module(customer, target_module, target_server=None):
    '''
    rollback a single module, if target_server is given, it will only rollback the module on the target server
    '''
    # load config
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    rollback_settings = load_yaml('%s/%s.yaml' % (customer_path, deploy_config['rollback']['version']))
    
    if target_server is None:
        modules_to_hosts_config = load_yaml('%s/services.yaml' % customer_path)
        target_hosts = get_hosts_of_target(modules_to_hosts_config, target_module, 'modules')
        
        for host in target_hosts:
            restart_module_impl(target_module, host, rollback_settings)
    else:
        restart_module_impl(target_module, target_server, rollback_settings)
        
def protected_stat(customer):
    '''
    show FAQ only stat
    '''
    # load config
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    
    # query config server
    url, data = get_url_and_data(deploy_config)
    
    # return  parse query result
    return is_faq_only(data)

def protected_enable(customer):
    '''
    enable FAQ only
    '''
    # load config 
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    consul_config = deploy_config['consul']
    
    # query config server
    url, data = get_url_and_data(deploy_config)
    
    # override old setting
    data.update({DC_QAONLY_KEY: ' true'})
    send_faq_config(url, consul_config['dckey'], data)
    
    logger.info('enable FAQ only')

def protected_disable(customer):
    '''
    disable FAQ only
    '''
    # load config 
    customer_path = '%s/../../customer/%s/' % (dir_path, customer)
    deploy_config = load_yaml('%s/config.yaml' % customer_path)
    consul_config = deploy_config['consul']
    
    # query config server
    url, data = get_url_and_data(deploy_config)
    try:
        del data[DC_QAONLY_KEY]
    except:
        return
    
    # override old setting
    send_faq_config(url, consul_config['dckey'], data)
    
    logger.info('disable FAQ only')