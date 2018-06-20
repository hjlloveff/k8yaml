#!/bin/bash

# ==================================================================
# module
# ==================================================================
# response system

./restart module/wordtovecservice.yaml
./restart module/sentence-type.yaml
./restart module/common-parser-service.yaml
./restart module/function-intent.yaml
./restart module/intent-support.yaml
./restart module/emotion-support.yaml
./restart module/custom-inference-service.yaml
./restart module/function-content.yaml
./restart module/robotwriter.yaml

./restart module/snlu-all.yaml
./restart module/chat-service.yaml
./restart module/faq-module-20.yaml
./restart module/task-engine.yaml
./restart module/function-web-service.yaml

./restart module/emotibot-controller-20-nodeport.yaml
./restart module/emotibot-controller-20.yaml

#ui
./restart module/solr-etl-agent.yaml
./restart module/bot-factory-backend-service.yaml
./restart module/admin-ui-nodeport.yaml
./restart module/admin-ui.yaml
./restart module/multicustomer.yaml

