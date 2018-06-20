#!/bin/bash

printf "\e[31msolr \e[0m \n"
curl -sS -X GET "http://172.17.0.1:8081/solr/3rd_core/select?q=database%3A%22csbot_other%22&rows=1&wt=json&indent=true"

printf "\e[31mconsul \e[0m \n"
curl -sS -X GET 'http://172.17.0.1:8500/v1/catalog/service/solr'

printf "\n\e[31msentence-type \e[0m \n"
curl -sS -X GET "http://172.17.0.1:13401/getType?s=我不喜歡�"

printf "\n\e[31mcommon-parser-service \e[0m \n"
curl -sS -X GET 'http://172.17.0.1:14901/common-parser-service?text=我想明天订一张去上海的机票&tags=time_module'

printf "\n\e[31mintent-support \e[0m \n"
curl -sS -X GET 'http://172.17.0.1:21302/intent/?sentence=%E8%AE%B2%E7%AC%91%E8%AF%9D'

printf "\n\e[31mfunction-intent \e[0m \n"
curl -sS -X GET 'http://172.17.0.1:14399/intent/?sentence=%E8%AE%B2%E7%AC%91%E8%AF%9D'

printf "\n\e[31memotion-support \e[0m \n"
curl -sS -X GET "http://172.17.0.1:21103/mood?uniqueID=123&sentence=%E6%B0%94%E6%AD%BB%E6%88%91"

printf "\n\e[31mwordtovecservice \e[0m \n"
curl -sS -X GET "http://172.17.0.1:11501/qq_similarity?src=今天天气不错&tar=你觉得今天天气怎么样"

printf "\n\e[31mcustom-inference-service \e[0m \n"
curl -sS -X POST http://172.17.0.1:15601/similar -d '{ "user_q":"test1", "match_q":["test1","test2"] }'

printf "\n\e[31msnlu-all \e[0m \n"
curl -sS http://172.17.0.1:13901 -H "Content-Type: application/json" -d '{"queries":["我喜  欢你"],"flags":"segment","appid":"csbot"}'

printf "\n\e[31mfaq-module-20 \e[0m \n"
curl -sS http://172.17.0.1:11014 -H "Content-Type: application/json" -d '{"Text":"DemoQ","UserId":"123","Robot":"csbot", "UniqueId":"111"}'

printf "\n\e[31mchat-service \e[0m \n"
curl -sS -X GET "http://172.17.0.1:10930/chat?robot=csbot&uuId=xxxxx&userId=xxxx&userQ=%E4%BD%A0%E7%9A%84%E7%94%9F%E6%97%A5%E6%98%AF"

printf "\n\e[31mtask-engine \e[0m \n"
curl -sS -X POST -d '{"AppID": "csbot", "UserID": "0", "CU": {}, "Intent": "", "Text": "%E6%88%91%E8%A6%81%E7%9C%8B%E5%A4%A7%E8%A9%B1%E8%A5%BF%E9%81%8A=", "QualifiedScenarioIDs": ["60db8b29-1005-4bc8-92a2-c4605d9a75c3"]}' http://172.17.0.1:14101/task_engine/ET

printf "\n\e[31memotibot-controller-20 \e[0m \n"
curl -sS -X POST -d '{"userId":"123", "uniqueId":"123", "question":"你的生日是", "robotId":"csbot"}'  http://172.17.0.1:8080/QAtest
printf "\n"
curl -sS -X POST -d '{"userId":"123", "uniqueId":"123", "question":"转账的时候录错对方信息", "robotId":"csbot"}'  http://172.17.0.1:8080/QAtest

printf "\n\e[31mmulticustomer \e[0m \n"
curl -sS -X GET 172.17.0.1:14501/_health_check

printf "\n\e[31mbot-bot-factory-backend-service \e[0m \n"
curl -sS -X GET 172.17.0.1:15501/_health_check

printf "\n\e[31mrobotwriter \e[0m \n"
curl -sS -X GET http://172.17.0.1:10101/V2/weather?city_name=北京

printf "\n\e[31mfunction-content \e[0m \n"
curl -sS -X GET "http://172.17.0.1:14001/exchange/V1/query?do=currency_by_code&from=JPY&to=BHD"

printf "\n\e[31mfunction-web-service \e[0m \n"
curl -sS -X POST -d '{"Text0":"1-1","Text1":"1-1","Text1_Old":"1-1","UserID":"787a1b57da75fa43bacb49339bcd3b25","UniqueID":"20180413102536961835647","robot":"csbot","AfterRewriteInfo":{"intent_zoo":{"ver":"1.0.0","res":[{"item":"做，算术","score":90.0,"other_info":[]}],"status":"OK"},"CustomCU":[{"type":"userDefine","intent":{"ver":"1.0.5","res":[],"status":"OK"}}]},"CustomCU":[]}' -H "Content-Type: application/json"  http://172.17.0.1:13501/function/post
printf "\n"




