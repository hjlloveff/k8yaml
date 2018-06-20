'''
Created on 2017/08/18

@author: Ken Chang
'''

class NoSuchInfrastructureException(Exception):
    def __init__(self, message, errors):
        # Call the base class constructor with the parameters it needs
        super(Exception, self).__init__('Can not find the infrastructure')

        # Now for your custom code...
        self.errors = errors

class NoSuchModuleException(Exception):
    def __init__(self, message, errors):
        # Call the base class constructor with the parameters it needs
        super(Exception, self).__init__('Can not find the module')

        # Now for your custom code...
        self.errors = errors
        
class InfraIsNotUpException(Exception):
    def __init__(self, infra_name, errors=1):
        super(Exception, self).__init__('Infrastructure %s is not up!!' % infra_name)
        
        self.errors = errors
        
class ChatModuleIsNotUpException(Exception):
    def __init__(self, infra_name, errors=1):
        super(Exception, self).__init__('Chat module %s is not up!!' % infra_name)
        
        self.errors = errors
        
class NotIndicatedImageException(Exception):
    def __init__(self, errors=1):
        super(Exception, self).__init__('Image information does not found!!')
        
        self.errors = errors
        