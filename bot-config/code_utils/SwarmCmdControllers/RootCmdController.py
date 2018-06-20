from cement.core.controller import CementBaseController

CONTROLLER_DESCRIPTION = "script for deploying modules under docker swarm mode"
CONTROLLER_LABEL = 'base'

class RootCmdController(CementBaseController):
    '''
    base controller which only display description of the script
    '''
    class Meta:
        label = CONTROLLER_LABEL
        description = CONTROLLER_DESCRIPTION
        epilog = "This is the text at the bottom of --help."

    pass