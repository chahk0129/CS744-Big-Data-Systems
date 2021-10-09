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
mkdir output;
ssh node1 mkdir ${node1}/output
ssh node2 mkdir ${node2}/output
ssh node3 mkdir ${node3}/output

for n in $num_nodes; do
	if [[ "$n" = "1" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat

	elif [[ "$n" = "2" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank1.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 >> output/num${n}_rank1.out"

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank1.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1.stat

	elif [[ "$n" = "3" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank1.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank2.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 >> output/num${n}_rank1.out" &
		ssh node2 "$export_cmd; cd ${node2}; python main.py --master-ip $master_ip --num-nodes $n --rank 2 >> output/num${n}_rank2.out" 

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank1.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank2.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2.stat

	elif [[ "$n" = "4" ]]; then
		## collects network stats of all nodes before execution
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank1.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank2.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2.stat
		echo -e "---------- Network Stat. (Before) -------------" >> output/num${n}_rank3.stat
		ssh node3 cat /proc/net/dev >> output/num${n}_rank3.stat

		## app execution
		python main.py --master-ip $master_ip --num-nodes $n --rank 0 >> output/num${n}_rank0.out &
		ssh node1 "$export_cmd; cd ${node1}; python main.py --master-ip $master_ip --num-nodes $n --rank 1 >> output/num${n}_rank1.out" &
		ssh node2 "$export_cmd; cd ${node2}; python main.py --master-ip $master_ip --num-nodes $n --rank 2 >> output/num${n}_rank2.out" &
		ssh node3 "$export_cmd; cd ${node3}; python main.py --master-ip $master_ip --num-nodes $n --rank 3 >> output/num${n}_rank3.out" 

		## collects network stats of all nodes after execution
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank0.stat
		cat /proc/net/dev >> output/num${n}_rank0.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank1.stat
		ssh node1 cat /proc/net/dev >> output/num${n}_rank1.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank2.stat
		ssh node2 cat /proc/net/dev >> output/num${n}_rank2.stat
		echo -e "---------- Network Stat. (After) -------------" >> output/num${n}_rank3.stat
		ssh node3 cat /proc/net/dev >> output/num${n}_rank3.stat

	else
		echo "Not supported number of nodes! (only supported up to 4)"
		exit 1
	fi
done
