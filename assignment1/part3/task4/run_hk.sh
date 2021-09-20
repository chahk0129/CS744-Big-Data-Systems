#!/bin/bash

if [[ "$@" = *--help ]] || [[ "$@" = *-h ]]; then
	echo "Usage: ./run.sh [options]"
	echo -e "\t[input_name] [num_partition] runs pagerank with the input parameter (web-BerkStan | enwiki-pages-articles) and the number of partition"
	echo -e "\t[clear] cleans up the output files in hdfs directory"
	exit 1
fi

## Clean up resources
if [  "$1" = "clear" ]; then
	hdfs dfsadmin -safemode leave
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/web-BerkStan.txt
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/enwiki-pages-articles
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/web-BerkStan.out
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/enwiki-pages-articles.out
	hdfs dfsadmin -safemode enter
	exit 1	
fi

if [[ "$1" != "web-BerkStan" ]] && [[ "$1" != "enwiki-pages-articles" ]] || [[ "$2" = "" ]] || [[ "$2" < 1 ]]; then
	echo "Usage: ./run.sh [options]"
	echo -e "\t[input_name] [num_partition] runs pagerank with the input parameter (web-BerkStan | enwiki-pages-articles) and the number of partition"
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
echo -e "---------- Network Stat. -------------" >> logs/namenode_stat.before
cat /proc/net/dev >> logs/namenode_stat.before
echo -e "\n\n---------- Disk Stat. -------------" >> logs/namenode_stat.before
cat /proc/diskstats >> logs/namenode_stat.before

echo -e "---------- Network Stat. -------------" >> logs/datanode1_stat.before
ssh node1 cat /proc/net/dev >> logs/datanode1_stat.before
echo -e "\n\n---------- Disk Stat. -------------" >> logs/datanode1_stat.before
ssh node1 cat /proc/diskstats >> logs/datanode1_stat.before

echo -e "---------- Network Stat. -------------" >> logs/datanode2_stat.before
ssh node2 cat /proc/net/dev >> logs/datanode2_stat.before
echo -e "\n\n---------- Disk Stat. -------------" >> logs/datanode2_stat.before
ssh node2 cat /proc/diskstats >> logs/datanode2_stat.before

sleep 2

driver_memory=8G
executor_memory=8G

## Run pagerank application
if [ "$1" = "web-BerkStan" ]; then
	## add local input file (web-BerkStan.txt) to hdfs
	hdfs dfs -put ../web-BerkStan.txt ${assignment1_dir}/web-BerkStan.txt
	echo "Running pagerank_cache with web-BerkStan.txt"
	spark-submit --class "pagerank_cached" --driver-memory ${driver_memory} --executor-memory ${executor_memory} pagerank_cache.py ${assignment1_dir}/web-BerkStan.txt ${assignment1_dir}/web-BerkStan.cache ${num_partition} &> logs/web-BerkStan.log
else
	## add local input file (enwiki-pages-articles) to hdfs
	hdfs dfs -put /proj/uwmadison744-f21-PG0/data-part3/enwiki-pages-articles/ ${assignment1_dir}/enwiki-pages-articles
	echo "Running pagerank_cache enwiki-pages-articles"
	spark-submit --class "pagerank_cached" --driver-memory ${driver_memory} --executor-memory ${executor_memory} pagerank_cache.py ${assignment1_dir}/enwiki-pages-articles ${assignment1_dir}/enwiki-pages-articles.cache ${num_partition} &> logs/enwiki-pages-articles.log
fi

sleep 2

## Collect stats after execution
echo -e "---------- Network Stat. -------------" >> logs/namenode_stat.after
cat /proc/net/dev >> logs/namenode_stat.after
echo -e "\n\n---------- Disk Stat. -------------" >> logs/namenode_stat.after
cat /proc/diskstats >> logs/namenode_stat.after

echo -e "---------- Network Stat. -------------" >> logs/datanode1_stat.after
ssh node1 cat /proc/net/dev >> logs/datanode1_stat.after
echo -e "\n\n---------- Disk Stat. -------------" >> logs/datanode1_stat.after
ssh node1 cat /proc/diskstats >> logs/datanode1_stat.after

echo -e "---------- Network Stat. -------------" >> logs/datanode2_stat.after
ssh node2 cat /proc/net/dev >> logs/datanode2_stat.after
echo -e "\n\n---------- Disk Stat. -------------" >> logs/datanode2_stat.after
ssh node2 cat /proc/diskstats >> logs/datanode2_stat.after


## Read output file
if [ "$1" = "web-BerkStan" ]; then
	hdfs dfs -cat ${assignment1_dir}/web-BerkStan.cache/*
else
	hdfs dfs -cat ${assignment1_dir}/enwiki-pages-articles.cache/*
fi

## Enter hdfs safemode
hdfs dfsadmin -safemode enter
