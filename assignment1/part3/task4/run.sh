#!/bin/bash

if [[ "$@" = *--help ]] || [[ "$@" = *-h ]]; then
	echo "Usage: ./run.sh [options] [num_partition] [executor_memory_size] [host_IP]"
	echo -e "\t[input_name] runs pagerank with the input parameter (web-BerkStan | enwiki-pages-articles)"
	echo -e "\t[clear] cleans up the output files in hdfs directory"
	exit 1
fi

## Clean up resources
if [  "$1" = "clear" ]; then
	hdfs dfsadmin -safemode leave
	#hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/web-BerkStan.txt
	#hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/enwiki-pages-articles
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/web-BerkStan.kill_process
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/enwiki-pages-articles.kill_process
	hdfs dfsadmin -safemode enter
	exit 1	
fi

if [[ "$1" != "web-BerkStan" ]] && [[ "$1" != "enwiki-pages-articles" ]] || [[ "$2" = "" ]] || [[ "$2" < 1 ]] || [[ "$3" = "" ]] || [[ "$3" < 1 ]] || [[ "$4" = "" ]]; then
	echo "Usage: ./run.sh [options] [num_partition] [executor_memory_size] [host_IP]"
	echo -e "\t[input_name] runs pagerank with the input parameter (web-BerkStan | enwiki-pages-articles)"
	echo -e "\t[clear] cleans up the output files in hdfs directory"
	exit 1
fi

num_partition=$2

## Leave hdfs safemode
hdfs dfsadmin -safemode leave

## namenode path
namenode_dir=hdfs://10.10.1.1:9000

## Make directory paths
hadoop fs -mkdir ${namenode_dir}/user
hadoop fs -mkdir ${namenode_dir}/user/hcha
hadoop fs -mkdir ${namenode_dir}/user/hcha/assignment1

## Set assignment1 default path
assignment1_dir=${namenode_dir}/user/hcha/assignment1


## Collect stats before execution
mkdir logs
echo -e "---------- Network Stat. (After) -------------" >> logs/$1_part$2_mem$3_namenode.stat
cat /proc/net/dev >> logs/$1_part$2_mem$3_namenode.stat
echo -e "\n\n---------- Disk Stat. (After) -------------" >> logs/$1_part$2_mem$3_namenode.stat
cat /proc/diskstats >> logs/$1_part$2_mem$3_namenode.stat

echo -e "---------- Network Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode1.stat
ssh node1 cat /proc/net/dev >> logs/$1_part$2_mem$3_datanode1.stat
echo -e "\n\n---------- Disk Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode1.stat
ssh node1 cat /proc/diskstats >> logs/$1_part$2_mem$3_datanode1.stat

echo -e "---------- Network Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode2.stat
ssh node2 cat /proc/net/dev >> logs/$1_part$2_mem$3_datanode2.stat
echo -e "\n\n---------- Disk Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode2.stat
ssh node2 cat /proc/diskstats >> logs/$1_part$2_mem$3_datanode2.stat

sleep 2

driver_memory=30G
executor_memory=$3G
ip=$4

## Run pagerank application
if [ "$1" = "web-BerkStan" ]; then
	## add local input file (web-BerkStan.txt) to hdfs
	hdfs dfs -put ../web-BerkStan.txt ${assignment1_dir}/web-BerkStan.txt
	echo "Running pagerank_kill_process with web-BerkStan.txt"
	echo "num_partition(${num_partition}), executor_mem(${executor_memory})" >> logs/web-BerkStan.log
	spark-submit --master spark://$ip:7077 --class "pagerank_kill_process" --driver-memory ${driver_memory} --executor-memory ${executor_memory} --num-executors 2 --executor-cores 5 pagerank_cache.py ${assignment1_dir}/web-BerkStan.txt ${assignment1_dir}/web-BerkStan.kill_process ${num_partition} >> logs/web-BerkStan.log
else
	## add local input file (enwiki-pages-articles) to hdfs
	hdfs dfs -put /proj/uwmadison744-f21-PG0/data-part3/enwiki-pages-articles/ ${assignment1_dir}/enwiki-pages-articles
	echo "Running pagerank_kill_process enwiki-pages-articles"
	echo "num_partition(${num_partition}), executor_mem(${executor_memory})" >> logs/enwiki-pages-articles.log
	spark-submit --master spark://$ip:7077 --class "pagerank_kill_process" --driver-memory ${driver_memory} --executor-memory ${executor_memory} --num-executors 2 --executor-cores 5 pagerank_cache.py ${assignment1_dir}/enwiki-pages-articles ${assignment1_dir}/enwiki-pages-articles.kill_process ${num_partition} >> logs/enwiki-pages-articles.log
fi

sleep 2

## Collect stats after execution
echo -e "---------- Network Stat. (After) -------------" >> logs/$1_part$2_mem$3_namenode.stat
cat /proc/net/dev >> logs/$1_part$2_mem$3_namenode.stat
echo -e "\n\n---------- Disk Stat. (After) -------------" >> logs/$1_part$2_mem$3_namenode.stat
cat /proc/diskstats >> logs/$1_part$2_mem$3_namenode.stat

echo -e "---------- Network Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode1.stat
ssh node1 cat /proc/net/dev >> logs/$1_part$2_mem$3_datanode1.stat
echo -e "\n\n---------- Disk Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode1.stat
ssh node1 cat /proc/diskstats >> logs/$1_part$2_mem$3_datanode1.stat

echo -e "---------- Network Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode2.stat
ssh node2 cat /proc/net/dev >> logs/$1_part$2_mem$3_datanode2.stat
echo -e "\n\n---------- Disk Stat. (After) -------------" >> logs/$1_part$2_mem$3_datanode2.stat
ssh node2 cat /proc/diskstats >> logs/$1_part$2_mem$3_datanode2.stat




## Read output file
if [ "$1" = "web-BerkStan" ]; then
	hdfs dfs -cat ${assignment1_dir}/web-BerkStan.kill_process/* 2>/dev/null | head
else
	hdfs dfs -cat ${assignment1_dir}/enwiki-pages-articles.kill_process/* 2>/dev/null | head
fi

## Enter hdfs safemode
hdfs dfsadmin -safemode enter
