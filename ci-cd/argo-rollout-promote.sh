#!/bin/bash

SERVICE_NAME=
NAMESPACE=
URL=


curl -X PUT https://${URL}/api/v1/rollouts/$NAMESPACE/${SERVICE_NAME}-rollout/promote \                                                                     [12:03:07]
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"name": "${SERVICE_NAME}-rollout",
"namespace": "$NAMESPACE",
"full": false
}' | jq
