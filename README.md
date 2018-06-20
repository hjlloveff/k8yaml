一、说明

此说明文件为all in one 的布署步骤，k8s步骤请看k8s_deploy/README.md

二、布属步骤

1. 清空container

   a. ./clear_container.sh

2. 布属所有东西
   
   a. 修改 init-db/docker/local.env INIT_MYSQL_INIT, 若为初次布署请设为true

   b. ./deploy.sh


三、测试

1. 连到admin-ui(port 80)确认正常显示，预设帐密csbotadmin/csbot@1

2. 使用curl脚本确认个模组正常

    a. ./curl.sh

       curl-ans为参考输出结果
