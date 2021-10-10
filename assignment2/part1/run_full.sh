#!/bin/bash

ip=10.10.1.1

mkdir -p output

for ep in $epoch; do
	python main.py --master-ip $ip --num-nodes 1 --rank 0 --epoch 25 --stop_iter 200 >> output/25_200.out
done
