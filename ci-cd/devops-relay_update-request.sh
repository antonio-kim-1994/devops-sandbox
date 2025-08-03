#!/bin/bash
DEVOPS_RELAY_URL=
DATE=2024-12-04T10:56:33+09:00
ORG=
OPERATOR=
REPO=
DOCKER_TAG=
COMMIT_MESSAGE="/api/v1/argo/update: github input parameter 수정"
SLACK_WEBHOOK_URL=

curl -X POST https://${$DEVOPS_RELAY_URL}/api/v1/argo/update  \
-H "Content-Type: application/json" \
-d '{ 
  "date": "$DATE",
  "org": "$ORG",
  "operator": "$OPERATOR",
  "repo": "$REPO",
  "docker_tag": "$DOCKER_TAG",
  "commit_message": "$COMMIT_MESSAGE",
  "slack_webhook_url": "$SLACK_WEBHOOK_URL"
}'
