'''
@author: zhangchenhui
'''

import os
import subprocess
from code_utils import check_host, query_service_config, get_service_env_variables, get_host_name
from code_utils.SwarmCmdControllers import RootCmdController, BaseCmdController
from cement.core.controller import CementBaseController, expose

CONTROLLER_DESCRIPTION = 'rollback a service to previous version'
ARGUMENTS = [
    (['-n', '--name'], dict(help="service name, ex: speechact", action='store', dest='name', required=True)),
]

class RollbackCmdController(BaseCmdController.BaseCmdController):
    
    '''
    controller which rollback a service 
    '''
    class Meta:
        label = 'rollback'
        description = CONTROLLER_DESCRIPTION
        epilog = "This is the text at the bottom of --help."
        stacked_on = RootCmdController.CONTROLLER_LABEL
        stacked_type = 'nested'
        
        arguments = ARGUMENTS
    
    @expose('help=rollback a docker swarm service', hide=True)
    def default(self):
        app = self.app
        
        # create cmd 
        cmd = ["docker service update --rollback %s" % app.pargs.name]
        
        subprocess.call(cmd, shell=True)