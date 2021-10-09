#!/bin/bash

## get ip address of namenode
ip_addr=$(hostname -I)
ip=(${ip_addr//" "/ })

master_ip=10.10.1.1
num_nodes="1 2 3 4"

## directory info for all nodes
node0=cs744/assignment2/part2/taskA
node1=cs744/assignment2/part2/taskA
node2=cs744/assignment2/part2/taskA
node3=cs744/assignment2/part2/taskA

## create output directories 
mkdir output;

for n in $num_nodes; do
	if [[ "$n" = "1" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out
	elif [[ "$n" = "2" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 &>> output/num${n}_rank0.out
		ssh node1 python ${node1}/main.py --master-ip $master_ip --num-nodes $n --rank 1 &>> output/num${n}_rank1.out
	elif [[ "$n" = "3" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 &>> output/num${n}_rank0.out
		ssh node1 python ${node1}/main.py --master-ip $master_ip --num-nodes $n --rank 1 &>> output/num${n}_rank1.out
		ssh node2 python ${node2}/main.py --master-ip $master_ip --num-nodes $n --rank 2 >> output/num${n}_rank2.out
	elif [[ "$n" = "4" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 &>> output/num${n}_rank0.out
		ssh node1 python ${node1}/main.py --master-ip $master_ip --num-nodes $n --rank 1 &>> output/num${n}_rank1.out
		ssh node2 python ${node2}/main.py --master-ip $master_ip --num-nodes $n --rank 2 &>> output/num${n}_rank2.out
		ssh node3 python ${node3}/main.py --master-ip $master_ip --num-nodes $n --rank 3 >> output/num${n}_rank2.out
	else
		echo "Not supported number of nodes! (only supported up to 4)"
		exit 1
	fi
done
