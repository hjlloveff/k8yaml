一、说明

为了让以后其他专案也能使用，此布署脚本大多使用csbot做命名，
跟namespace有关的都会去读档案"namespace" 要使用其他名字更改此即可

二、k8s布属步骤

1. 创建此次布署的namespace(需要跟档案namespace内容相同)

    a.  kubectl create namespace minsheng

2. 设置標籤：

    a. kubectl label node {ip} csbot=db

       db: mysql, consul, solr

注意：以下步骤务必等待上一个步骤起的docker都已经成功开启才进下一步

3. 布署db
    
    a. ./deploy_db.sh

4. 初始化consul, mysql

    a. 修改init/init-db.yaml: 根據solr數量打入"solr-{0-N}.solr"，
       ex: 初始solr replica為2，設定如下
        - name: INIT_SOLR_HOSTS
          value: "solr-0.solr,solr-1.solr"
	 - name: INIT_SOLR_PORTS
          value: "8983,8983"
       注意逗点前后不要有空白
    b. ./up init/init-db.yaml

5. 布署module

    a. ./deploy_module.sh

    部分模组初始化需要一段时间(1 - 3 min)请耐心等候

三、测试

1. 连到admin-ui确认正常显示，预设帐密csbotadmin/csbot@1

2. 使用curl脚本确认个模组正常

    a. ./curl.sh

       ../curl-ans为参考输出结果
