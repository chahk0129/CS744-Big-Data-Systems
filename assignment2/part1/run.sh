#!/bin/bash

ip=10.10.1.1
iter=2 4 6 8 10

mkdir -p output

for it in $iter; do
	python main.py --master-ip $ip --num-nodes 1 --rank 0 --exp_iter $it >> output/${it}.out
done
