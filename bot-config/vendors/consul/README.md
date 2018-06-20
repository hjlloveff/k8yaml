# How to run/restart consul config server
```
./restart.sh <env> <role> <leader-ip>

env: consul 需要綁定network interface, 所以會從xxx.env 讀取要綁定的interface(定義在 TARGET_INTERFACE)
role: consul分為兩種角色, leader and follower, follwer 會嘗試加入leader的cluster, 當部署all-in-one環境，請使用leader
leader-ip(optional): 當consul 角色為follower, 則此consul 需要指名leader的所在, 並嘗試加入 cluster
```