'''
This script dumps docker images by indicated target env, 
it will iterate service_conf.py,
find service which match target env,
and save docker images as tar files to output folder
'''

import os
import subprocess
from service_conf import conf
from code_utils import  query_service_config
from code_utils.Exceptions import EnvNotExistException
from cement.core.foundation import CementApp
from cement.core.controller import CementBaseController, expose

CONTROLLER_DESCRIPTION = 'dump images by indecated target env'
ARGUMENTS = [
    (['-e', '--env'], dict(help="env, ex: sta", action='store', dest='env', required=True)),
    (['-o', '--output'], dict(help="output path, create the path if not exist", action='store', dest='output', required=True))
]

class DumpCmdController(CementBaseController):
    
    '''
    controller which rollback a service 
    '''
    class Meta:
        label = 'base'
        description = CONTROLLER_DESCRIPTION
        arguments = ARGUMENTS
        
    def parse_docker_img_name(self, file):
        with open(file, 'r') as f:
            content = f.readline()
            repo=''
            container_name=''
            for line in f:
                if 'REPO=' in line:
                    repo = line.replace("REPO=", "")
                    repo = repo.replace("\n", "")
                
                if 'CONTAINER=' in line:
                    container_name = line.replace("CONTAINER=", "")
                    container_name = container_name.replace("\n", "")
                    
                if repo != '' and container_name != '':
                    break
                
        
        if repo != '' and container_name != '':
            return '%s/%s' % (repo, container_name)
        else:
            return None
        
    @expose('help=dump target env', hide=True)
    def default(self):
        app = self.app
        env = app.pargs.env
        output = app.pargs.output
        services = conf['services']
        
        # iterate services
        for service in services:
            if 'run' not in service:
                continue
            
            # parse docker images and tag
            try:
                service_conf = query_service_config(service['service_name'], app.pargs.env)
            except EnvNotExistException:
                continue
            
            root_path = "%s/../../" % os.path.split(os.path.abspath(__file__))[0]
            run_script = '%s%s/%s' %(root_path, service_conf['path'], service_conf['run'])
            docker_name = self.parse_docker_img_name(run_script)
            if docker_name is None:
                continue
            
            docker_img = '%s:%s' % (docker_name, service_conf['tag'])
            
            # pull docker_img
            cmd = 'docker pull %s' % docker_img
            subprocess.call(cmd, shell=True)
            
            # dump docker img
            container_name = docker_name.split("/")[1]
            cmd = 'docker save -o %s/%s-%s-%s.tar %s' % (output, container_name,  service['service_name'],  service_conf['tag'], docker_img) 
            subprocess.call(cmd, shell=True)
            
        
        dbs = conf['dbs']
        # dump db
        for db in dbs:
            db_name=db['db_name']
            for db_env in db['envs']:
                env_name = db_env['name']
                if env == env_name:
                    image = '%s:%s' % (db['image'], db_env['tag'])
                    
                    cmd = 'docker pull %s' % image
                    subprocess.call(cmd, shell=True)
                    
                    cmd = 'docker save -o %s/%s-%s.tar %s' % (output, db_name, db['db_name'], image)
                    subprocess.call(cmd, shell=True)
            
    

class DumpImagesApp(CementApp):
    class Meta:
        label = 'image-dumper'
        base_controller = 'base'
        handlers = [
            DumpCmdController,
        ]
        
def main():
    with DumpImagesApp() as app:
        app.run()

if __name__ == '__main__':
    main()
