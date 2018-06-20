# -*- coding: utf-8 -*-
'''
Dictionary for service config:
'''
conf = {
  "services": [
   # RCWV/ 15 / 11500 / wordtovecservice (rc_word2vec)
    {
      "service_name": "wordtovecservice",
      "path": "modules/wordtovecservice",
      "run": "run.sh",
      "prefix": "RCWV",
      "envs": [
        {
          "name": "minSheng",
          "tag":"e42c588-SUSE",
          "host": [
          ]
        }
      ]
    },
    # SEA / 44 / 14401 / solr-etl-agent
    {
      "service_name": "solr-etl-agent",
      "path": "modules/solr-etl-agent",
      "run": "run.sh",
      "envs": [
        {
          "name": "minSheng",
          "tag": "6f1867a-SUSE",
          "host": [
          ]
        }
      ]
    },
    # MC/  45 / 14500 / multicustomer
    {
      "service_name": "multicustomer",
      "path": "modules/multicustomer",
      "run": "run.sh",
      "envs": [
        {
          "name": "minSheng",
          "tag":"minSheng2018051110-b837369",
          "host": [
          ]
        }
      ]
    },
    # snlu-all
    {
      "service_name": "snlu-all",
      "path": "modules/snlu-all",
      "run": "run.sh",
      "prefix": "SNLU",
      "envs": [
        {
          "name": "minSheng",
          "tag": "b2ed413",
          "host": [
          ]
        }
      ]
    },
    # CIS / 56 / 15601 / custom-inference-service
    {
      "service_name": "custom-inference-service",
      "path": "modules/custom-inference-service",
      "run": "run.sh",
      "prefix": "CIS",
      "envs": [
        {
          "name": "minSheng",
          "tag": "da02b61",
          "host": [
          ]
        }
      ]
    },
    # faq service
    {
      "service_name": "faq-module-2.0",
      "path": "modules/faq-module-2.0",
      "run": "run.sh",
      "prefix": "FAQ",
      "envs": [
        {
          "name": "minSheng",
          "tag": "2018041911-60bbf7c",
          "host": [
          ]
        }
      ]
    },
    # chat service
    {
      "service_name": "chat-service",
      "path": "modules/chat-service",
      "run": "run.sh",
      "prefix": "CHAT",
      "envs": [
        {
          "name": "minSheng",
          "tag": "2018032311-6cf8015",
          "host": [
          ]
        }
      ]
    },
    # controller2.0
    {
      "service_name": "emotibot-controller-20",
      "path": "modules/emotibot-controller-20",
      "run": "run.sh",
      "prefix": "EC2.0",
      "envs": [
        {
          "name": "minSheng",
          "tag": "20180511-de35a7a",
          "host": [
          ]
        }
      ]
    },
    {
      "service_name": "function-intent",
      "path": "modules/function-intent",
      "run": "run.sh",
      "prefix": "INTENT",
      "envs": [
        {
          "name": "minSheng",
          #"tag": "a06f3ac_function_intent",
          "tag": "0466565-SUSE",
          "host": [
          ]
        }
      ]
    },
    {
      "service_name": "intent-support",
      "path": "modules/intent-support",
      "run": "run.sh",
      "prefix": "INTENT",
      "envs": [
        {
          "name": "minShengno",
          "tag": "v4.1.0",
          "host": [
          ]
        }
      ]
    },
    {
      "service_name": "human-intent",
      "path": "modules/human-intent",
      "run": "run.sh",
      "prefix": "INTENT",
      "envs": [
        {
          "name": "minSheng",
          "tag": "v4.1.0",
          "host": [
          ]
        }
      ]
    },
    # TE / 41 / 14101 / task-engine
    {
      "service_name": "task-engine",
      "path": "modules/task-engine",
      "run": "run.sh",
      "prefix": "TE",
      "envs": [
        {
          "name":"minSheng",
          "tag":"f147c13-SUSE",
          "host": [
          ]
        }
      ]
    },
    #emotion-support
    {
      "service_name":"emotion-support",
      "path":"modules/emotion-support",
      "run": "run.sh",
      "prefix":"EMOTION",
      "envs": [
        {
          "name": "minSheng",
          "tag":"c90b5b5-SUSE",
          "host": [
          ]
        }
      ]
    },
    # CPS / 49 / 14901 / common-parser-service
    {
      "service_name": "common-parser-service",
      "path": "modules/common-parser-service",
      "run": "run.sh",
      "prefix": "CPS",
      "envs": [
        {
          "name": "minSheng",
          "tag":"4ffde0f-SUSE",
          "host": [
          ]
        }
      ]     
    },
    # ST / 34 / 13401 / sentence-type
    {
      "service_name": "sentence-type",
      "path": "modules/sentence-type",
      "run": "run.sh",
      "envs": [
        {
          "name": "minSheng",
          "tag": "91dc74a-SUSE",
          "host": [
          ]
        },
      ]
    },
    #function-web-service
    {
      "service_name": "function-web-service",
      "path": "modules/function-web-service",
      "run": "run.sh",
      "prefix": "FUNC",
      "envs": [
        {
          "name": "minSheng",
          "tag": "2018051110-191dfc6",
          "host": [
          ]
        }
      ]
    },
    
    {
      "service_name": "robotwriter",
      "path": "modules/robotwriter",
      "run": "run.sh",
      "prefix": "RW",
      "envs": [
        {
          "name": "minSheng",
          "tag": "20180413-19de1a6-SUSE",
          "host": [
          ]
        }
      ]
    },

    {
      "service_name": "function-content",
      "path": "modules/function-content",
      "run": "run.sh",
      "prefix": "FC",
      "envs": [
        {
          "name": "minSheng",
          "tag": "26df658-SUSE",
          "host": [
          ]
        }
      ]
    },

    # BFB / 55 / 15501 / bot-factory-backend-service
    {
      "service_name": "bot-factory-backend-service",
      "path": "modules/bot-factory-backend-service",
      "prefix": "BFB",
      "run": "run.sh",
      "envs": [
        {
          "name": "minSheng",
          "tag": "20180511-69c627d-SUSE",
          "host": [
              "minsheng",
          ]
        },
      ]
    },
    {
      "service_name": "admin-ui",
      "path": "modules/admin-ui",
      "run": "run.sh",
      "prefix": "ADMIN",
      "envs": [
        {
          "name": "minSheng",
#          "tag": "20180417-aab50c2",
          "tag": "20180511-ced432d",
          "host": [
            "minsheng",
          ]
        }
      ]
    },
    {
      "service_name": "emotibot-cronjob",
      "path": "modules/emotibot-cronjob",
      "run": "run.sh",
      "prefix": "CRONJOB",
      "envs": [
        {
          "name": "minSheng",
          "tag": "20180509-c719311",
          "host": [
            "minsheng",
          ]
        }
      ]
    }
  ],
  # list db here not for deploying, but for dumping
  "dbs": [
    {
        "db_name":"solr",
        "image":"solr",
        "envs" : [
         {
            "name":"minSheng",
            "tag":"5.5-SUSE",
         }
        ]
    },
    {
        "db_name":"mysql",
        "image":"mysql",
        "envs" : [
          {
            "name":"minSheng",
            "tag":"5.7",
          }
        ]
    },
    {
        "db_name":"consul",
        "image":"consul",
        "envs" : [
          {
            "name":"minSheng",
            "tag":"1.0.2-SUSE",
          }
        ]
    },
  ]
}
