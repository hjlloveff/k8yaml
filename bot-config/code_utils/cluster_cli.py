'''
What this script does:
1. it load server settings from yaml
2. it calls action defined in cli.py through SSH

@author: zhangchenhui
'''
import os
import sys
import base64

import requests
import yaml
import socket
from paramiko.client import SSHClient, AutoAddPolicy
from cement.core.foundation import CementApp
from cement.core.controller import CementBaseController, expose


CONSUL_KV_API = 'v1/kv'
DC_CONSUL_KEY = 'idc/dc/vipshop'
DC_QAONLY_KEY = 'service_vipFAQonly'


def _send(host, key, data):
    url = os.path.join(host, CONSUL_KV_API, key)
    data_ = ''
    for k in data.keys():
        if data_:
            data_ = '%s\n' % data_
        data_ = '%s%s=%s' % (data_, k, data[k])
    # print 'url: %s, data: %s' % (url, data_)
    try:
        requests.put(url, data=data_, timeout=(5, 5))
    except Exception as exp:
        print 'put %s to %s failed.(%s)' % (data, url, exp)
        sys.exit(1)


def _get_data(host=None, key=None):
    def _default_node():
        return {
            'service_Faq': 'true',
            'service_Dg': 'false',
            'service_Ibb': 'false',
            'service_Memory': 'false'
        }

    url = os.path.join(host, CONSUL_KV_API, key)
    # print 'url: %s' % url
    try:
        resp = requests.get(url, timeout=(5, 5))
    except Exception as exp:
        print 'get value failed: %s(%s)' % (url, exp)
        sys.exit(1)

    try:
        resp.raise_for_status()
    except Exception as exp:
        print 'get %s failed.(%s)' % (key, resp.status_code)
        sys.exit(1)

    resp_list = list()
    try:
        resp_list = resp.json()
    except Exception as exp:
        print 'convert %s to list failed.(%s)' % (resp.content, exp)
        sys.exit(1)

    assert isinstance(resp_list, list)
    try:
        node = resp_list.pop(0)
        value = node.get('Value', '')
        if not value:
            return _default_node()
        b64_value = base64.b64decode(value)
        datas = b64_value.split('\n')
        # print datas
        d = dict()
        for data in datas:
            pairs = data.split('=')
            d[pairs[0]] = pairs[1]
        return d

    except IndexError:
        return _default_node()


def create_ssh_client(host, account, password, port=22):
    client = SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(AutoAddPolicy())

    client.connect(host, port=port, username=account, password=password)
    return client

def load_config():
    with open("clusters.yaml") as stream:
        try:
            return yaml.load(stream)
        except yaml.YAMLError as exc:
            print(exc)
            sys.exit()

def parse_argument(cmd_handler):
    name = cmd_handler.app.pargs.name
    target_cluster = cmd_handler.app.pargs.target_cluster

    return name, target_cluster


class DeployHandler():
    def __init__(self):
        self.config = load_config()


    def compose_cmd(self, type, target, cli_path="/home/deployer/bot-config/code_utils/", env="", conf_file=""):
        cmd = "cd %s; python cli.py %s deploy %s %s %s" % (cli_path, type, target, env, conf_file)
        return cmd

    def do_deploy(self, cmd, clusters):
        """
        send a deploy service command through ssh to target servers
        """

        # get servers
        servers = []
        for cluster in clusters:
            if cluster == '':
                continue
            servers += self.get_server_list(cluster)

        # send command to target server
        user = self.config['admin_info']['user']
        pw = self.config['admin_info']['pw']
        for server in servers:
            try:
                client = create_ssh_client(server, user, pw)
                stdin, stdout, stderr = client.exec_command(cmd)
                print stdout.read()
                print stderr.read()
                client.close()
            except socket.gaierror as e:
                self._print_error(e, server)
            except socket.error as e:
                self._print_error(e, server)

    def get_server_list(self, cluster_name):
        # a cluster may contain multiple servers
        # so we return list of servers
        servers = []

        if cluster_name in self.config['clusters']:
            servers = self.config['clusters'][cluster_name]
        else:
            servers.append(cluster_name)

        return servers

        pass

    def _print_error(self, error, server):
        print(error)
        print server

class InfrastructureCmdHandler(CementBaseController):
    class Meta:
        label = "infrastructure"
        stacked_on = "deploy"
        stacked_type = 'embedded'

        arguments = [
            (['-j', '--join_to'], dict(help="indicate where consul leader is", action='store', dest='join_to')),
        ]

    def __init__(self, *args, **kargs):
        super(CementBaseController, self).__init__(*args, **kargs)
        self.action = DeployHandler()


    def _compose_cmd(self, infrastructure, argument):
        # TODO(ken): not hard code path in the script
        emotigo_deployment_path = '/home/deployer/emotigo/deployment/logging'
        botconfig_deployment_path = '/home/deployer/bot-config/'
        houta_deployment_path = '/home/deployer/houta/'

        cmd = ''
        if infrastructure == 'filebeat':
            cmd = 'cd %s/filebeat; ./restart.sh %s' % (emotigo_deployment_path, argument)
        elif infrastructure == 'logstash':
            cmd = 'cd %s/logstash/docker; ./run.sh %s' % (emotigo_deployment_path, argument)
        elif infrastructure == 'consul-leader':
            cmd = 'cd %s/vendors/consul; ./restart.sh vip leader' % (botconfig_deployment_path)
        elif infrastructure == 'consul-follower':
            cmd = 'cd %s/vendors/consul; ./restart.sh vip follower %s' % (botconfig_deployment_path, argument)
        elif infrastructure == 'houta':
            cmd = 'cd %s/docker; ./run.sh vip-cluster.env' % (houta_deployment_path)

        return cmd
        pass

    def _assert_env(self, infrastructure):
        if infrastructure == 'filebeat' or infrastructure == 'logstash':
            if self.app.pargs.env is None:
                print "when deploy filebeat or logstash, you should give target environment"
                sys.exit()

        elif infrastructure == 'consul-follower':
            if self.app.pargs.join_to is None:
                print "when deploy a consul follower, you should give join to which consul leader"
                sys.exit()


    def _retrive_argument(self, infrastructure):
        if infrastructure == 'filebeat' or infrastructure == 'logstash':
            return self.app.pargs.env
        elif infrastructure == 'consul-follower':
            return self.app.pargs.join_to


    @expose(help='deploy infrastructures to clusters')
    def infrastructure(self):
        """
        do infrastructure deployment
        """

        target_name, target_clusters = parse_argument(self)

        self._assert_env(target_name)

        argument = self._retrive_argument(target_name)
        cmd = self._compose_cmd(target_name, argument)

        if cmd == '':
            print "Try to deploy a undefined infrastructure!"
            sys.exit()

        # split input clusters
        clusters = target_clusters.split(",")

        self.action.do_deploy(cmd, clusters)

class DeployCmdHandler(CementBaseController):
    '''
    create cli command and send to target clusters,
    '''
    class Meta:
        label = "deploy"
        stacked_on = "base"
        stacked_type = 'nested'
        description = "deploy services to clusters"

        arguments = [
            (['-n', '--name'], dict(help="target name, ex: speechact, solr, consul", action='store', dest='name', required=True)),
            (['-t', '--to'], dict(help="target cluster', ex: idc45, 192.168.1.28, chat-servers", action='store', dest='target_cluster', required=True)),
            (['-e', '--env'], dict(help="target env, ex: idc, vip, dev", action='store', dest='env')),
            (['-c', '--conf_file'], dict(help="enf file", action='store', dest='conf')),
        ]



    def __init__(self, *args, **kargs):
        super(CementBaseController, self).__init__(*args, **kargs)
        self.action = DeployHandler()


    @expose(help='', hide=True)
    def default(self):
        print "deploy service"

    @expose(help='deploy services to clusters')
    def service(self):
        """
        do service deployment
        """
        env = self.app.pargs.env
        conf = self.app.pargs.conf

        if env is None or conf is None:
            print "when deploy a service, you should give target environment and which env file to use"
            sys.exit()

        target_name, target_clusters = parse_argument(self)

        # split input clusters
        clusters = target_clusters.split(",")

        # compose command
        cmd = self.action.compose_cmd("service", target_name, env=env, conf_file="/home/deployer/bot-config/conf/generated/%s" % conf)
        print cmd

        self.action.do_deploy(cmd, clusters)


    @expose(help='deploy databases to clusters')
    def database(self):
        """
        do database deployment
        """

        target_name, target_clusters = parse_argument(self)

        # split input clusters
        clusters = target_clusters.split(",")

        # compose command
        cmd = self.action.compose_cmd("database", target_name)

        self.action.do_deploy(cmd, clusters)


    @expose(help="deploy a defined suite to clusters")
    def suite(self):
        """
        TODO(ken): deploy a service suite, like bot-factory, chat-bot, or etc.
        """
        print "deploy suite"



class DeployCmdController(CementBaseController):
    '''
    class which handles deploy command
    '''
    class Meta:
        label = "base"
        description = "deploy service/infrastructures/DBs to clusters"
        epilog = "This is the text at the bottom of --help."


class ProtectedModeCmdHandler(CementBaseController):
    class Meta:
        label = "protected"
        stacked_on = "base"
        stacked_type = 'nested'
        # stacked_type = 'embedded'

        description = 'protected mode controller'
        arguments = [
            (['--host'],
             dict(action='store',
                  help='consul server host',
                  default='http://consul-sh.emotibot.com')),
            (['--port'],
             dict(action='store',
                  help='consul server port',
                  default=8500)),
            (['--key'],
             dict(action='store',
                  help='consul server monitoring key',
                  default='idc/dc/vipshop'))
        ]

    @expose(help='list current protected mode status')
    def stat(self):
        url = '%s:%s' % (self.app.pargs.host, self.app.pargs.port)
        data = _get_data(url, self.app.pargs.key)
        for k in data.keys():
            if k == DC_QAONLY_KEY and 'true' in data[k]:
                print 'Enable'
                return
        print 'Disable'

    @expose(help='disable protected mode')
    def disable(self):
        url = '%s:%s' % (self.app.pargs.host, self.app.pargs.port)
        data = _get_data(url, self.app.pargs.key)
        try:
            del data[DC_QAONLY_KEY]
        except:
            return
        _send(url, self.app.pargs.key, data)
        self.stat()

    @expose(help='enable protected mode')
    def enable(self):
        url = '%s:%s' % (self.app.pargs.host, self.app.pargs.port)
        data = _get_data(url, self.app.pargs.key)
        data.update({DC_QAONLY_KEY: ' true'})
        _send(url, self.app.pargs.key, data)
        self.stat()


class ClusterCli(CementApp):
    class Meta:
        label = 'cluster_cli'
        handlers = [
            DeployCmdController,
            DeployCmdHandler,
            InfrastructureCmdHandler,
            ProtectedModeCmdHandler,
        ]


def main():
    with ClusterCli() as app:
        app.run()

if __name__ == '__main__':
    main()

