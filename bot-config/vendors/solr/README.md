# How to run/restart solr
```
# requirement:
# 1. docker installed 
# 2. sudoer 權限
# 3. bot-config
# 4. deployer user(optional)
 
Deployment steps:
1. mkdir -p /home/deployer/infrastructure/volumes/solr (如果不以deployer 帳號來運行的話, 記得修改 bot-config/env.sh, 把 HOME_PATH=/home/deployer 改成 HOME_PATH=/home/$YOUR_USERNAME)
 
2. cp bot-config/vendors/solr/conf/solr.xml /home/deployer/infrastructure/volumes/solr (solr 運行必須要有solr.xml, 否則啟動時會報錯)
 
3. chown -R 8983:8983 /home/deployer/infrastructure/volumes/solr (solr 以8983 來access volume, 請確保solr volume 的owner:group 是8983:8983 )
 
4. cd bot-config/vendors/solr/; ./restart.sh (運行solr 遇到 solr.xml 沒有權限的問題，請忽視)
 
測試：
用遊覽器打開 http://<your-ip>:8081,頁面上沒有任何錯誤訊息, 表示solr正常運行
```