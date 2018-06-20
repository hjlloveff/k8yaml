#!/bin/bash
namespace=$(<namespace)

printf "\e[31msolr \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET "http://solr:8983/solr/3rd_core/select?q=database%3A%22csbot_other%22&rows=1&wt=json&indent=true"

printf "\e[31mconsul \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET 'http://localhost:8500/v1/catalog/service/solr'

printf "\n\e[31msentence-type \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET "http://sentence-type:8080/getType?s=我不喜歡�"

printf "\n\e[31mcommon-parser-service \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET 'http://common-parser-service:8080/common-parser-service?text=我想明天订一张去上海的机票&tags=time_module'

printf "\n\e[31mintent-support \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET 'http://intent-support:8080/intent/?sentence=%E8%AE%B2%E7%AC%91%E8%AF%9D'

printf "\n\e[31mfunction-intent \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET 'http://function-intent:8080/intent/?sentence=%E8%AE%B2%E7%AC%91%E8%AF%9D'

printf "\n\e[31memotion-support \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET "http://emotion-support:8080/mood?uniqueID=123&sentence=%E6%B0%94%E6%AD%BB%E6%88%91"

printf "\n\e[31mwordtovecservice \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET "http://wordtovecservice:8080/qq_similarity?src=今天天气不错&tar=你觉得今天天气怎么样"

printf "\n\e[31mcustom-inference-service \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X POST http://custom-inference-service:8080/similar -d '{ "user_q":"test1", "match_q":["test1","test2"] }'

printf "\n\e[31msnlu-all \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS http://snlu-all:8080 -H "Content-Type: application/json" -d '{"queries":["我喜  欢你"],"flags":"segment","appid":"csbot"}'

printf "\n\e[31mfaq-module-20 \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS http://faq-module-20:8080 -H "Content-Type: application/json" -d '{"Text":"DemoQ","UserId":"123","Robot":"csbot", "UniqueId":"111"}'

printf "\n\e[31mchat-service \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET "http://chat-service:8080/chat?robot=csbot&uuId=xxxxx&userId=xxxx&userQ=%E4%BD%A0%E7%9A%84%E7%94%9F%E6%97%A5%E6%98%AF"

printf "\n\e[31mtask-engine \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X POST -d '{"AppID": "csbot", "UserID": "0", "CU": {}, "Intent": "", "Text": "%E6%88%91%E8%A6%81%E7%9C%8B%E5%A4%A7%E8%A9%B1%E8%A5%BF%E9%81%8A=", "QualifiedScenarioIDs": ["60db8b29-1005-4bc8-92a2-c4605d9a75c3"]}' http://task-engine:8080/task_engine/ET

printf "\n\e[31memotibot-controller-20 \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X POST -d '{"userId":"123", "uniqueId":"123", "question":"我爱民生", "robotId":"csbot"}'  http://emotibot-controller-20:8080/QAtest
printf "\n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X POST -d '{"userId":"123", "uniqueId":"123", "question":"你的生日是", "robotId":"csbot"}'  http://emotibot-controller-20:8080/QAtest
printf "\n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X POST -d '{"userId":"123", "uniqueId":"123", "question":"转账的时候录错对方信息", "robotId":"csbot"}'  http://emotibot-controller-20:8080/QAtest

printf "\n\e[31mmulticustomer \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET multicustomer:8080/_health_check

printf "\n\e[31mbot-bot-factory-backend-service \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET bot-factory-backend-service:8080/_health_check

printf "\n\e[31mrobotwriter \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET http://robotwriter:8080/V2/weather?city_name=åäº¬

printf "\n\e[31mfunction-content \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X GET "http://function-content:8080/exchange/V1/query?do=currency_by_code&from=JPY&to=BHD"

printf "\n\e[31mfunction-web-service \e[0m \n"
kubectl exec consul-0 --namespace=$namespace -- \
curl -sS -X POST -d '{"Text0":"1-1","Text1":"1-1","Text1_Old":"1-1","UserID":"787a1b57da75fa43bacb49339bcd3b25","UniqueID":"20180413102536961835647","robot":"csbot","AfterRewriteInfo":{"intent_zoo":{"ver":"1.0.0","res":[{"item":"做，算术","score":90.0,"other_info":[]}],"status":"OK"},"CustomCU":[{"type":"userDefine","intent":{"ver":"1.0.5","res":[],"status":"OK"}}]},"CustomCU":[]}' -H "Content-Type: application/json"  http://function-web-service:8080/function/post
printf "\n"




