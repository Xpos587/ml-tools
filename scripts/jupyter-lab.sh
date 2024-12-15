#!/bin/bash
cd /home/clore
while true; do
  jupyter lab \
    --ip=127.0.0.1 \
    --port=8888 \
    --no-browser \
    --ServerApp.base_url=/jupyter/ \
    --NotebookApp.token='' \
    --NotebookApp.password='' \
    --ServerApp.allow_origin='*' \
    --ServerApp.disable_check_xsrf=True \
    --ServerApp.trust_xheaders=True
  sleep 1
done
