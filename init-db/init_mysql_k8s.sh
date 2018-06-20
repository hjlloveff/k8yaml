# make sure are put under /home/deployer/sqls

kubectl exec -i mysql-0 --namespace=minsheng -- mysql -uroot -pCmbctest123 < authentication.sql
kubectl exec -i mysql-0 --namespace=minsheng -- mysql -uroot -pCmbctest123 < emotibot.sql
kubectl exec -i mysql-0 --namespace=minsheng -- mysql -uroot -pCmbctest123 < backend_log.sql
kubectl exec -i mysql-0 --namespace=minsheng -- mysql -uroot -pCmbctest123 < task_init.sql

