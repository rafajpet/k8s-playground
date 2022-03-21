#!/bin/bash

./start-k3s.sh \
  --k3s=true \
  --nginx=true \
  --prometheus=true \
  --resources=true \
  --loki=true