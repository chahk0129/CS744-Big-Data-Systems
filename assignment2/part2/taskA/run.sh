#!/bin/bash

## get ip address of namenode
ip_addr=$(hostname -I)
ip=(${ip_addr//" "/ })

master_ip=10.10.1.1
num_nodes="4"
#num_nodes="1 2 3 4"

## directory info for all nodes
node0=cs744/assignment2/part2/taskA
node1=cs744/assignment2/part2/taskA
node2=cs744/assignment2/part2/taskA
node3=cs744/assignment2/part2/taskA

## expor path for all nodes for conda path
export_cmd="export PATH=\"/users/hcha/miniconda3/bin:\$PATH\""

## create output directories 
mkdir output;
ssh node1 mkdir ${node1}/output
ssh node2 mkdir ${node2}/output
ssh node3 mkdir ${node3}/output

for n in $num_nodes; do
	if [[ "$n" = "1" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out
	elif [[ "$n" = "2" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 >> output/num${n}_rank1.out"
	elif [[ "$n" = "3" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 >> output/num${n}_rank1.out" &
		ssh node2 "$export_cmd; cd ${node2}; python main.py --master-ip $master_ip --num-nodes $n --rank 2 >> output/num${n}_rank2.out" 
	elif [[ "$n" = "4" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 >> output/num${n}_rank1.out" &
		ssh node2 "$export_cmd; cd ${node2}; python main.py --master-ip $master_ip --num-nodes $n --rank 2 >> output/num${n}_rank2.out" &
		ssh node3 "$export_cmd; cd ${node3}; python main.py --master-ip $master_ip --num-nodes $n --rank 3 >> output/num${n}_rank3.out" 
	else
		echo "Not supported number of nodes! (only supported up to 4)"
		exit 1
	fi
done
