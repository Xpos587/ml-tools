#!/bin/bash
source /opt/mamba/bin/activate default
cd /home/clore
while true; do
  jupyter lab --ip='127.0.0.1' --NotebookApp.token='' --NotebookApp.password='' --no-browser
  sleep 1
done
