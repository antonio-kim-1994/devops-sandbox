#!/bin/bash
ACCOUNT_ID=""

kubectl -n homepage run -it --rm devops-playground --image=${ACCOUNT_ID}.dkr.ecr.ap-northeast-2.amazonaws.com/devops/tools:1.0.0-alpine --restart=Never --overrides='
{
  "metadata": {
    "annotations": {
      "sidecar.istio.io/inject": "false"
    }
  }
}' -- /bin/sh


kubectl -n devops run -it --rm devops-playground --image=busybox --restart=Never --overrides='
{
  "metadata": {
    "annotations": {
      "sidecar.istio.io/inject": "false"
    }
  }
}' -- /bin/sh


kubectl -n devops run -it --rm devops-playground --image=tutum/dnsutils --restart=Never --overrides='
{
  "metadata": {
    "annotations": {
      "sidecar.istio.io/inject": "false"
    }
  }
}' -- /bin/sh