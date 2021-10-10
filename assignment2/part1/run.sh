#!/bin/bash

ip=10.10.1.1

mkdir -p output

python main.py --master-ip $ip --num-nodes 1 --rank 0  >> output/1_40.out
