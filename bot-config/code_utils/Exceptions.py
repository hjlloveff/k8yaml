'''
Exceptions
'''

class ServiceNotExistException(Exception):
    def __init__(self, message='Unknow service!!'):
        super(ServiceNotExistException, self).__init__(message)

class EnvNotExistException(Exception):
    def __init__(self, message='Unknow environment!!'):
        super(EnvNotExistException, self).__init__(message)
    pass


class NotAllowedHostExceptoin(Exception):
    def __init__(self, message="Try to deploy on not allowed machine"):

        # Call the base class constructor with the parameters it needs
        super(NotAllowedHostExceptoin, self).__init__(message)

    pass
