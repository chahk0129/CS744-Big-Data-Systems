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

## expor path for all nodes for conda path
export_cmd="export PATH=\"/users/hcha/miniconda3/bin:\$PATH\""

## create output directories 
mkdir -p output;
ssh node1 mkdir -p ${node1}/output
ssh node2 mkdir -p ${node2}/output
ssh node3 mkdir -p ${node3}/output

for n in $num_nodes; do
	if [[ "$n" = "1" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 --epoch 25 --stop_iter 400 >> output/num${n}_rank0_full.out

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat

	elif [[ "$n" = "2" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank1_full.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1_full.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 --epoch 25 --stop_iter 400 >> output/num${n}_rank0_full.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes --epoch 25 --stop_iter 400 $n --rank 1 >> output/num${n}_rank1_full.out"

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank1_full.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1_full.stat

	elif [[ "$n" = "3" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank1_full.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1_full.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank2_full.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2_full.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 --epoch 25 --stop_iter 400 >> output/num${n}_rank0_full.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 --epoch 25 --stop_iter 400 >> output/num${n}_rank1_full.out" &
		ssh node2 "$export_cmd; cd ${node2}; python main.py --master-ip $master_ip --num-nodes $n --rank 2 --epoch 25 --stop_iter 400>> output/num${n}_rank2_full.out" 

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank1_full.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1_full.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank2_full.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2_full.stat

	elif [[ "$n" = "4" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank1_full.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1_full.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank2_full.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2_full.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank3_full.stat
		ssh node3 cat /proc/net/dev >> output/num${n}_rank3_full.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 --epoch 25 --stop_iter 400 >> output/num${n}_rank0_full.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 --epoch 25 --stop_iter 400 >> output/num${n}_rank1_full.out" &
		ssh node2 "$export_cmd; cd ${node2}; python main.py --master-ip $master_ip --num-nodes $n --rank 2 --epoch 25 --stop_iter 400 >> output/num${n}_rank2_full.out" &
		ssh node3 "$export_cmd; cd ${node3}; python main.py --master-ip $master_ip --num-nodes $n --rank 3 --epoch 25 --stop_iter 400 >> output/num${n}_rank3_full.out" 

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0_full.stat
		cat /proc/net/dev >> output/num${n}_rank0_full.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank1_full.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1_full.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank2_full.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2_full.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank3_full.stat
		ssh node3 cat /proc/net/dev >> output/num${n}_rank3_full.stat

	else
		echo "Not supported number of nodes! (only supported up to 4)"
		exit 1
	fi
done
