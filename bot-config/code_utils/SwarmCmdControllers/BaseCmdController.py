from cement.core.controller import CementBaseController

class BaseCmdController(CementBaseController):
    
    '''
    base class for command controllers
    '''
    
    def attach_replica(self, source, replica_num):
        return source +" --replicas %s" % str(replica_num)
    