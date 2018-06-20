import os
import subprocess
from code_utils import check_host, query_service_config, get_service_env_variables, get_host_name
from code_utils.SwarmCmdControllers import RootCmdController, BaseCmdController
from cement.core.controller import CementBaseController, expose

CONTROLLER_DESCRIPTION = 'update a docker swarm service'

ARGUMENTS = [
    (['-n', '--name'], dict(help="service name, ex: speechact", action='store', dest='name', required=True)),
    (['-e', '--env'], dict(help="running environemnt, ex: dev", action='store', dest='env', required=True)),
    (['-c', '--conf_file'], dict(help="environment varibles conf file", action='store', dest='conf_file', required=True)),
    (['-i', '--ignore_env_checking'], dict(help="when applied, ignore environment checking", action='store_true', dest='ignore')),
    (['-f', '--force'], dict(help="force update even when not changed", action='store_true', dest='force')),
    (['-r', '--replicas'], dict(help="replicas number", action='store', dest='replicas', default=1)),
]

class UpdateCmdController(BaseCmdController.BaseCmdController):
    '''
    controller which create a service into docker swarm env
    '''
    class Meta:
        label = 'update'
        description = CONTROLLER_DESCRIPTION
        epilog = "This is the text at the bottom of --help."
        stacked_on = RootCmdController.CONTROLLER_LABEL
        stacked_type = 'nested'
        
        arguments = ARGUMENTS
      
    @expose('help=update a docker swarm service', hide=True)  
    def default(self):
        app = self.app
        cwd = os.getcwd()
        
        # get service config
        service_conf = query_service_config(app.pargs.name, app.pargs.env)
        hostname = get_host_name()
        
        # check if enabled host
        check_host(service_conf['host'], hostname, app.pargs.ignore)
        
        # fetch env variables
        env_list = get_service_env_variables('conf/generated/%s' % app.pargs.conf_file, service_conf['prefix'])
        
        # update cmd 
        script_path = '%s/%s' % (service_conf['path'], service_conf['update'])
        conf_file_path = '%s/conf/generated/%s' % (cwd, app.pargs.conf_file)
        tag = service_conf['tag']
        envs = self.create_envs(env_list)
        
        envs = self.attach_replica(envs, app.pargs.replicas)
        
        if app.pargs.force:
            envs = self.attach_force(envs, app.pargs.force)
        
        cmd = [script_path, conf_file_path, tag, envs]
        
        subprocess.call(cmd)
        pass
    
    def create_envs(self, env_list):
        env_str = ""
        for env in env_list:
            env_str += "--env-add %s " % env
        
        return env_str
        pass
    
    def attach_force(self, source, force):
        if force is True:
            return source + " --force"
        else:
            return source
        