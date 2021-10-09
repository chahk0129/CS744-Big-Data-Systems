#!/bin/bash

## get ip address of namenode
ip_addr=$(hostname -I)
ip=(${ip_addr//" "/ })

master_ip=10.10.1.1
num_nodes="1 2 3 4"

## directory info for all nodes
node0=cs744/assignment2/part3
node1=cs744/assignment2/part3
node2=cs744/assignment2/part3
node3=cs744/assignment2/part3

## create output directories 
mkdir output;
ssh node1 mkdir ${node1}/output
ssh node2 mkdir ${node2}/output
ssh node3 mkdir ${node3}/output

for n in $num_nodes; do
	if [[ "$n" = "1" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/${n}.out
	elif [[ "$n" = "2" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 &>> output/${n}_rank0.out
		ssh node1 python ${node1}/main.py --master-ip $master_ip --num-nodes $n --rank 1 &>> ${node1}/output/${n}_rank1.out
	elif [[ "$n" = "3" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 &>> output/${n}_rank0.out
		ssh node1 python ${node1}/main.py --master-ip $master_ip --num-nodes $n --rank 1 &>> ${node1}/output/${n}_rank1.out
		ssh node2 python ${node2}/main.py --master-ip $master_ip --num-nodes $n --rank 2 >> ${node2}/output/${n}_rank2.out
	elif [[ "$n" = "4" ]]; then
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 &>> output/${n}_rank0.out
		ssh node1 python ${node1}/main.py --master-ip $master_ip --num-nodes $n --rank 1 &>> ${node1}/output/${n}_rank1.out
		ssh node2 python ${node2}/main.py --master-ip $master_ip --num-nodes $n --rank 2 &>> ${node2}/output/${n}_rank2.out
		ssh node3 python ${node3}/main.py --master-ip $master_ip --num-nodes $n --rank 3 >> ${node3}/output/${n}_rank2.out
	else
		echo "Not supported number of nodes! (only supported up to 4)"
		exit 1
	fi
done
