# 兴业部署检查单

## 模块清单&版本 -- 20171103 -- 定期sync&修改

- admin server: 192.100.90.51 or 192.100.90.52

|img name|version/tag|
|--------|-----------|
|cib|707b056|
|multicustomer|8d3ec6f|
|arangodb/arangodb:3.2.0|3.2.0|
|solr-etl-agent|2e91d14|
|bot-factory-backend-service|eded137|
|corbinu/docker-phpadmin||
|mysql|5.7|
|consul|0.8.4|
|solr|5.5|

- api server: 192.100.90.53 or 192.100.90.54

|img name|version/tag|
|--------|-----------|
|knowledgegraph|68ca00e|
|emotibot_controller_2.0|176c8c6|
|intent-support|19797ba|
|xy-sdk|xy_stable|
|function-web-service|39f34d1|
|faq_module_2.0|79605df|
|chat_service|5101b3b|
|snlu|157255a|
|rc_wrod2vec|86087a3|
|answer_classifier|0ac8973|
|customer_inference_service|da02b61|

- 以上两张列表中，靠前部的几个模块都是更新状态比较频繁的，在实际部署过程中更需要注意。

## 部署工具

为方便部署，使用一键部署脚本，以下分为添加新模块和更新原有模块两个方面来讲解。

### 添加新模块

模块添加后，需要修改部署脚本中的如下几个文件：
```
# 修改文件
conf/generated/xy.env
deploy_script/deploy_xy.sh
service_conf.py
# 添加文件
modules/xxx_module/run.sh
```

- env文件中需要加入该模块的配置项。注意，如该模块有请求admin server中的服务，需要对应将url改为192.100.90.51或192.100.90.52；同样的，对于请求api server的部分，则需要对应将url改为192.100.90.53或192.100.90.54。此外，所有模块统一使用MODULE_LOG_LEVEL参数作为日志输出等级控制。
- deploy_xy.sh文件中需要按照如下的格式添加服务执行命令。
```
python deploy.py --env xingye --conf_file $ENV_FILE --ignore_env_checking --service img-name
```
- service_conf.py中按照如下格式添加模块配置,主要是需要配置其TAG 
```
{
      "service_name": "img-name",
      "path": "modules/img-name",
      "run": "run.sh",
      "prefix": "PREFIX",
      "envs": [
        {
          "name": "xingye",
          "tag": "XXXXXXX",
          "host": [
          ]
        }
      ]
    }
```
- run.sh文件中，需要复制项目的run.sh文件并进行对应修改，具体操作可以防止其他已有模块进行。

### 更新原有模块
在原有配置项不变的基础上，对一个已由模块进行更新，更新service_conf.py中该服务对应的TAG即可。

### 部署
```
# admin server
cd xy-deploy/deploy_scripts
./run.sh xy.env admin-server

# api server
./run.sh xy.env api-server
```

## 定期更新流程

- 模块本地更新，上68
- 68测试：董择&兴业，测试通过
- 68上打包，save docker
- 通过远程传输将：数据，配置脚本，更新的包发至兴业
- 远程控制，根据admin-server或者api-server将包发至兴业对应的机器上
- 更新cib&multicustomer，上传新数据
- 启动更新脚本，更新模块
- 利用APP等方式测试功能


## 例外的包

- cib
- xy-sdk
docker stats $(docker ps --format={{.Names}})
