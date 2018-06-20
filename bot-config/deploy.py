import os
import sys
import argparse
import subprocess
import socket
from service_conf import conf
from code_utils.Exceptions import EnvNotExistException, NotAllowedHostExceptoin

Exceptions = {
    'EnvNotExistException': 'Unknow environment!!',
    'NotAllowedHostExceptoin': 'Try to deploy on not allowed machine',
    }

service_registry = {}

def parse_arguments(args):
    ap = argparse.ArgumentParser()
    ap.add_argument('--ignore_env_checking', action='store_true', help='when this flag is present, ignore checking environment')
    ap.add_argument('--service', required=True, help='task to run')
    ap.add_argument('--conf_file', required=True)
    ap.add_argument('--env', required=True)
    parsed_args = vars(ap.parse_args(args))
    
    return parsed_args

def load_service():
    global service_registry
    services = conf['services']
    for service in services:
        service_name = service['service_name']
        service_registry[service_name] = service
        
    return service_registry

def parse_env_setting(service):
    # transform list of env seettigns into dictionary
    envs = service['envs']
    env_dict = {}
    for env in envs:
        env_name = env['name']
        env_dict[env_name] = env
        
    return env_dict

def get_host_name():
    hostname = socket.gethostname().split('.')[0]
    return hostname
     

def deploy_all(target_env, conf_file, check_env):
    workingDir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(workingDir)
    rct = 0
    # iterate services in service_conf.py
    services = conf['services']
    for service in services:
        envs = parse_env_setting(service)
        if target_env in envs:
            # change working dir
            modulePath = os.path.join(workingDir, service["path"])
            os.chdir(modulePath)
            
            env = envs[target_env]
            hosts = env['host']
            hostname = get_host_name()
            
            if check_env and hostname not in hosts:
                os.chdir(workingDir)
                print "try to deploy service %s on a not allowed machine" % service['service_name']
                continue
            
            docker_tag = env['tag']

            command = ['./'+service['run'], '%s/conf/generated/%s' % (workingDir, conf_file), str(docker_tag)]
            print command
        
            returnCode = subprocess.call(command)
            if returnCode != 0:
                rct = returnCode
    
    return rct

        
    

def deploy(env, service_config, conf_file, check_env=True):
    workingDir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(workingDir)
    
    envs = parse_env_setting(service_config)
    if env in envs:
        modulePath = os.path.join(workingDir, service_config["path"])
        os.chdir(modulePath)
        
        env_setting = envs[env]
        hosts = env_setting['host']
        hostname = get_host_name()
        
        if check_env and hostname not in hosts:
            os.chdir(workingDir)
            raise NotAllowedHostExceptoin(Exceptions['NotAllowedHostExceptoin'])
        
        docker_tag = env_setting['tag']

        command = ['./'+service_config['run'], '%s/conf/generated/%s' % (workingDir, conf_file), str(docker_tag)]
        print command
        
        returnCode = subprocess.call(command)
    else:
        os.chdir(workingDir)
        raise EnvNotExistException(Exceptions['EnvNotExistException'])
    
    os.chdir(workingDir)
    return returnCode

def main():
    cl_args = parse_arguments(sys.argv[1:])
    service = cl_args['service']
    env = cl_args['env']
    check_env = not cl_args['ignore_env_checking']
    conf_file = cl_args['conf_file']
    
    services = load_service()
    
    # check service
    if service == 'all':
        rct = deploy_all(env, conf_file, check_env)
    elif service not in services:
        print 'can not identify service'
        rct = 1
    else:
        print "start deploy service: %s" % service
        rct = deploy(env, services[service], conf_file, check_env)
        
    sys.exit(rct)

if __name__ == '__main__':
    main()