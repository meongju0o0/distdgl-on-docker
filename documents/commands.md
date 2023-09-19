# commands

## common commands
- git clone https://github.com/meongju0o0/dist-dgl.git /workspace
- python3 /workspace/dist-dgl/launch.py --workspace /workspace/ --num_trainers 1 --num_samplers 0 --num_servers 1 --part_config 4part_data/ogbn-products.json --ip_config ip_config.txt "python3 train_dist.py"

## docker commands
- docker run -it --name python python:3.11.5-bullseye /bin/bash

## K8s commands
- kubectl delete all --all -n default
- kubectl delete pvc --all
- kubectl delete pv --all
- kubectl apply -f ~/distdgl-on-docker/volumes/graph-storage.yaml
- kubectl apply -f ~/distdgl-on-docker/partitioning/partitioning.yaml
