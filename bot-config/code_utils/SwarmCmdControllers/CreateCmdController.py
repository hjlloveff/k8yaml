import os
import subprocess
from service_conf import conf
from code_utils import check_host, query_service_config, get_service_env_variables, get_host_name
from code_utils.Exceptions import EnvNotExistException, NotAllowedHostExceptoin
from code_utils.SwarmCmdControllers import RootCmdController, BaseCmdController
from cement.core.controller import CementBaseController, expose

CONTROLLER_DESCRIPTION = 'create a service to docker swarm with name and replicas number'
ARGUMENTS = [
    (['-n', '--name'], dict(help="service name, ex: speechact", action='store', dest='name', default=None)),
    (['-e', '--env'], dict(help="running environemnt, ex: dev", action='store', dest='env', required=True)),
    (['-c', '--conf_file'], dict(help="environment varibles conf file", action='store', dest='conf_file', required=True)),
    (['-i', '--ignore_env_checking'], dict(help="when applied, ignore environment checking", action='store_true', dest='ignore')),
    (['-r', '--replicas'], dict(help="set replica number", action='store', dest='replicas', default=1)),
    (['-N', '--network'], dict(help="join to user-defined network", action='store', dest='network', default=None)),
]

class CreateCmdController(BaseCmdController.BaseCmdController):
    
    '''
    controller which create a service into docker swarm env
    '''
    class Meta:
        label = 'create'
        description = CONTROLLER_DESCRIPTION
        epilog = "This is the text at the bottom of --help."
        stacked_on = RootCmdController.CONTROLLER_LABEL
        stacked_type = 'nested'
        
        arguments = ARGUMENTS
    
    @expose('help=create a docker swarm service', hide=True)
    def default(self):
        app = self.app
        
        # get service config
        service_conf = query_service_config(app.pargs.name, app.pargs.env)
        hostname = get_host_name()
        
        # check if enabled host
        check_host(service_conf['host'], hostname, app.pargs.ignore)
        
        # fetch env variables
        envs = self.create_cmd_parameters(app.pargs.conf_file, service_conf['prefix'], app.pargs.replicas, app.pargs.network)
        
        self.create_service(service_conf, envs)
        
    @expose('help=create all docker swarm services whic are defined in service_conf')
    def all(self):
        app = self.app
        target_env = app.pargs.env
        target_env_file = app.pargs.conf_file
        
        for service in conf['services']:
            if 'create' not in service or 'update' not in service or 'prefix' not in service:
                continue
            
            service_name = service['service_name']
            try:
                service_conf = query_service_config(service_name, target_env)
                
                hostname = get_host_name()
                
                # check if enabled host
                check_host(service_conf['hosts'], hostname, app.pargs.ignore)
                
            except EnvNotExistException:
                continue
            except NotAllowedHostExceptoin:
                print "try to deploy %s on a not allowed machine" % service_name
                continue
                
            envs = self.create_cmd_parameters(app.pargs.conf_file, service_conf['prefix'], app.pargs.replicas, app.pargs.network)
                
            self.create_service(service_conf, envs)
            
            
    def create_cmd_parameters(self, conf_file, prefix, replicas=1, custom_network=None):
        env_list = get_service_env_variables('conf/generated/%s' % conf_file, prefix)
            
        envs = self.create_envs(env_list)
        envs = self.attach_replica(envs, replicas)
            
        # attch network if indicated
        if custom_network is not None:
            envs = self.attach_network(envs, custom_network)
        
        return envs
        
        
    def create_service(self, service_obj, envs):
        cwd = os.getcwd()
        
        script_path = '%s/%s' % (service_obj['path'], service_obj['create'])
        conf_file_path = '%s/conf/generated/%s' % (cwd, self.app.pargs.conf_file)
        tag = service_obj['tag']
        
        cmd = [script_path, conf_file_path, tag, envs]
        subprocess.call(cmd)
        
    def create_envs(self, env_list):
        env_str = ""
        for env in env_list:
            env_str += "-e %s " % env
            
        return env_str
        pass
    
    
    def attach_network(self, source, network):
        return source +" --network %s" % network
        
    