import traceback
import json
import sys
import os
import subprocess
import logging
from collections import namedtuple

try:
    import fire
except ImportError:
    sys.stderr.write('Please install python-fire first.\npip install fire\n')
    sys.exit(1)

# assume the cli.py must in bot-config
import sys
sys.path.append('../')
from service_conf import conf as service_config


LOG = logging.getLogger(__name__)


FILE_PATH = os.path.dirname(os.path.abspath(__file__))+"/../"
DATABASE_PATH = os.path.join(FILE_PATH, 'vendors')  # should be database
CONF_GENERATED_PATH = os.path.join(FILE_PATH, 'conf/generated')


DBCmdTuple = namedtuple('DBCmdTuple', ['name', 'deploy_cmd', 'init_cmd'])
InfraCmdTuple = namedtuple('InfraCmdTuple', ['name', 'deploy_cmd'])


def _check_ret(sys_exec_tuple):
    assert isinstance(sys_exec_tuple, tuple)
    type_, value, tb = sys_exec_tuple
    if type_ or value or tb:
        traceback.print_exception(type_, value, tb)


class Infra(object):
    '''dns server, consul config server, bot-factory, houta...

    >>> python cli.py infra list --detail
    >>> python cli.py infra deploy dns
    >>> python cli.py infra deploy consul
    >>> python cli.py infra deploy all
    '''
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)

    @property
    def support_infra(self):
        return {
            'dns': 'idc-dns/start.sh',
            'consul': 'consul/restart.sh',
            'haproxy': 'haproxy/run.sh',
            # 'docker_reg': 'docker_reg/run.sh'  #
            # https://docs.docker.com/registry/deploying/
        }

    def _compose_cmd(self, infra_name):
        '''
        '''
        ret_list = list()
        for infra in self.support_infra:
            if infra != infra_name and infra_name != 'all':
                continue
            cmd_full_path = os.path.join(FILE_PATH, self.support_infra[infra])
            ret_list.append(InfraCmdTuple(infra, cmd_full_path))
        return ret_list

    def deploy(self, infra_name):
        assert infra_name == 'all' or infra_name in self.support_infra, '%s is not supported' % infra_name

        cmd_tuple_list = self._compose_cmd(infra_name)

        for cmd in cmd_tuple_list:
            self.logger.info('cmd: %s', cmd)
            try:
                subprocess.check_output(cmd)
            except:
                break
        return sys.exc_info()

    def list(self, detail=False):
        cmd_list = self._compose_cmd('all')
        for cmd in cmd_list:
            if detail:
                sys.stdout.write('%s, %s\n' % (cmd.name, cmd.deploy_cmd))
            else:
                sys.stdout.write('%s\n' % cmd.name)


class Database(object):
    '''upper group, contain mysql, mongo, solr,..., etc
    >>> python cli.py database deploy mongo
    >>> python cli.py database deploy all
    >>> python cli.py database list
    >>> python cli.py database list --detail
    '''
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)

    def _compose_cmd(self, db_name, init=False):
        ret_list = list()
        for f in os.listdir(DATABASE_PATH):
            if f.startswith('.'):
                continue
            if db_name != 'all' and db_name != f:
                continue
            full_path = os.path.join(DATABASE_PATH, f)
            if not os.path.isdir(full_path):
                continue
            cmd_full_path = os.path.join(full_path, 'restart.sh')
            init_full_path = None
            if init:
                init_full_path = os.path.join(full_path, 'init.sh')
                if not os.path.exists(init_full_path):
                    init_full_path = None
            assert os.path.exists(cmd_full_path), '%s is not exists!' % cmd_full_path

            ret_list.append(DBCmdTuple(f, cmd_full_path, init_full_path))
        return ret_list

    def deploy(self, db_name, init=False):
        self.logger.info('deploy database %s', db_name)
        cmd_list = self._compose_cmd(db_name, init)
        self.logger.info('deploy database: %s', cmd_list)
        for cmd in cmd_list:
            self.logger.info('deploy_cmd: %s, init_cmd: %s',
                             cmd.deploy_cmd, cmd.init_cmd)
            try:
                subprocess.check_output(cmd.deploy_cmd)
                subprocess.check_output(cmd.init_cmd)
            except:
                break
        return sys.exc_info()

    def list(self, service=None, detail=False):
        if service is None:
            service = 'all'
        cmd_list = self._compose_cmd(service, init=True if detail else False)
        for cmd in cmd_list:
            if detail:
                sys.stdout.write('%s, %s, %s\n' % (cmd.name,
                                                   cmd.deploy_cmd,
                                                   cmd.init_cmd))
            else:
                sys.stdout.write('%s\n' % cmd.name)


class Service(object):
    '''uppder group, contain all modules as service

    >>> python cli.py service deploy robotwriter <env> <docker_tag>
    >>> python cli.py service list [--detail]
    '''
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)

    def _compose_cmd(self, service_name, env_name):
        '''
        :return: /abs_path/run.sh, /abs_path/{env}.env, docker tag
        '''
        run_path = env_path = docker_tag = None
        services = service_config['services']

        ret_tuple_list = list()
        for service in services:
            if service['service_name'] != service_name and service_name != 'all':
                continue
            # run sh
            base_path = service['path']
            assert base_path, 'service[path] is empty! %s' % service
            run_path = os.path.join(FILE_PATH, base_path, service['run'])
            # env
            for env in service['envs']:
                if env['name'] != env_name:
                    continue
                env_path = '%s/%s.env' % (CONF_GENERATED_PATH, env_name)
                docker_tag = env['tag']
                
                ret_t = (run_path, env_path, docker_tag)
                ret_tuple_list.append(ret_t)
        LOG.debug('return %s', ret_tuple_list)
        return ret_tuple_list

    def deploy(self, service, env, envfile=None):
        '''
        '''
        # TODO(mike): deploy to idc with ip ?
        cmd_tuple_list = self._compose_cmd(service, env)
        # assert os.path.exists(run_path), '%s is not exist!' % run_path
        # assert os.path.exists(env_path), '%s is not exist!' % env_path
        
        for cmd in cmd_tuple_list:
            run_path, env_path, docker_tag = cmd
            
            # change work dir to prevent some relative path issue
            run_script_path = os.path.dirname(os.path.abspath(run_path))
            os.chdir(run_script_path)
            
            env_path = envfile if envfile else env_path
            cmds = [run_path, env_path, docker_tag]
            self.logger.info('cmds: %s', cmds)
            try:
                subprocess.check_output(cmds)
            except:
                continue
            self.logger.debug('run_path: %s, env_path: %s, docker_tag: %s',
                              run_path, env_path, docker_tag)
        return sys.exc_info()

    def list(self, service=None, detail=False):
        services = service_config['services']
        if service is None or service == '':
            service = 'all'
        if service != 'all':
            detail = True

        for s in services:
            if s['service_name'] == service or service == 'all':
                if detail:
                    sys.stdout.write('%s\n' % json.dumps(s, indent=2))
                else:
                    sys.stdout.write('%s\n' % s['service_name'])
        sys.stdout.write('Total: %s\n' % len(services))


class Main(object):
    def __init__(self):
        # self._deploy_obj = Deploy()
        self._service_obj = Service()
        self._database_obj = Database()
        self._infra_obj = Infra()

    def deploy(self, resource, *args, **kwargs):
        '''deploy entrypoint

        resource: [service|database|infra]
        postarg: resource options

        >>> example: python cli.py deploy service cu dev envfile={abspath}/xxx.env
        >>> example: python cli.py deploy database mongo
        >>> example: python cli.py deploy infra dns
        '''
        if resource == 'service':
            _check_ret(self._service_obj.deploy(*args, **kwargs))
        elif resource == 'database':
            _check_ret(self._database_obj.deploy(*args, **kwargs))
        elif resource == 'infra':
            _check_ret(self._infra_obj.deploy(*args, **kwargs))
        elif resource == 'all':
            # 1) deploy infra. & test
            # 2) deploy database & test
            # 3) init database & test
            # 4) deploy service & test
            _check_ret(self._infra_obj.deploy('all', *args, **kwargs))
            _check_ret(self._database_obj.deploy('all', *args, init=True, **kwargs))
            _check_ret(self._service_obj.deploy('all', *args, **kwargs))
        else:
            assert 'Unsupport resource!'

    def clean(self, resource, *args, **kwargs):
        '''clean up resource

        resource: [database|infra|]
        >>> example: python cli.py clean database mongo
        >>> example: python cli.py clean service all
        >>> example: python cli.py clean all
        >>> example: python cli.py clean infra consul
        '''
        # TODO(mike)
        pass

    def service(self, cmd, *args, **kwargs):
        '''service entrypoint

        cmd: [list|deploy]
        env: [dev|sta|idc]
        >>> example: python cli.py service list all --detail
        >>> example: python cli.py service list robotwriter --detail
        >>> example: python cli.py service deploy all dev
        >>> example: python cli.py service deploy robotwriter dev
        '''
        cmd_func = getattr(self._service_obj, cmd, None)
        assert cmd_func and callable(cmd_func), '%s is invalid' % cmd
        cmd_func(*args, **kwargs)

    def database(self, cmd, *args, **kwargs):
        '''database entrypoint

        cmd: [list|deploy]
        list: return run script and init script
        >>> example: python cli.py database list --detail
        >>> example: python cli.py database deploy all
        >>> example: python cli.py database deploy mongo
        '''
        cmd_func = getattr(self._database_obj, cmd, None)
        assert cmd_func and callable(cmd_func), '%s is invalid' % cmd
        cmd_func(*args, **kwargs)

    def infra(self, cmd, *args, **kwargs):
        '''infra entrypoint

        cmd: [list|deploy]
        >>> example: python cli.py infra list --detail
        >>> example: python cli.py infra deploy all
        >>> example: python cli.py infra deploy dns
        '''
        cmd_func = getattr(self._infra_obj, cmd, None)
        assert cmd_func and callable(cmd_func), '%s is invalid' % cmd
        cmd_func(*args, **kwargs)


def main():
    fire.Fire(Main)


if __name__ == '__main__':
    import logging.config
    log_dict = {
        'version': 1,
        'disable_existing_loggers': False,
        'root': {
            'level': 'INFO',
            'handlers': ['console']
        },
        'handlers': {
            'console': {
                'class': 'logging.StreamHandler',
                'formatter': 'detail',
                'level': 'INFO'
            },
            # 'file': {
            #     'class': 'logging.handlers.RotatingFileHandler',
            #     'formatter': 'detail',
            #     'level': 'INFO',
            #     'filename': 'info.log',
            #     'maxBytes': 10 * 1024 * 1024,
            #     'backupCount': 10
            # }
        },
        'formatters': {
            'detail': {
                'format': u'[%(asctime)s][%(threadName)10.10s]'
                '[%(levelname).1s][%(filename)s:%(funcName)s:%(lineno)s]:'
                ' %(message)s'
            },
            'simple': {
                'format': u'[%(asctime)s][%(threadName)10.10s]'
                '[%(levelname).1s][%(filename)s:%(lineno)s]: %(message)s'
            }
        }
    }
    logging.config.dictConfig(log_dict)
    main()
