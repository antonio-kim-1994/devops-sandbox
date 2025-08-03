#!/bin/bash
kubectl run -it --rm test-busybox --image=busybox:1.28 --restart=Never --overrides='
{
  "metadata": {
    "annotations": {
      "sidecar.istio.io/inject": "false"
    }
  }
}' -- sh
