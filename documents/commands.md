# commands
- git clone https://github.com/meongju0o0/dist-dgl.git /workspace
- python3 /workspace/dist-dgl/launch.py --workspace /workspace/ --num_trainers 1 --num_samplers 0 --num_servers 1 --part_config 4part_data/ogbn-products.json --ip_config ip_config.txt "python3 train_dist.py"