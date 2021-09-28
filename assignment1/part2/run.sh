#!/bin/bash

if [[ "$@" = *--help ]] || [[ "$@" = *-h ]]; then
	echo "Usage: ./run.sh [options]"
	echo -e "\t[host_ip]: runs simple sort application with host IP address"
	echo -e "\t[clear]: cleans up the output in hdfs directory"
	exit 1
fi

## Clean up resources
if [  "$1" = "clear" ]; then
	hdfs dfsadmin -safemode leave 
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/output.csv
	hdfs dfsadmin -safemode enter
	rm data/*
	exit 1
fi

## check input ip
if [ "$1" = "" ]; then
	echo "Usage: ./run.sh [options]"
	echo -e "\t[host_ip]: runs simple sort application with host IP address"
	echo -e "\t[clear]: cleans up the output in hdfs directory"
	exit 1
fi

## create local data directory to store the returned input and output after execution
mkdir data


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

## Add local input file (export.csv) to hdfs
hdfs dfs -put export.csv ${assignment1_dir}/export.csv

## Validate the hdfs input file
hdfs dfs -cat ${assignment1_dir}/export.csv 2>/dev/null | head 

ip=$1

## Run the simple application (sort)
spark-submit --master spark://$ip:7077 --class "simple_sort" --driver-memory 30G --executor-memory 30G --num-executors 2 --executor-cores 5 part2_simple.py ${assignment1_dir}/export.csv ${assignment1_dir}/output.csv

## Read output file
hdfs dfs -cat ${assignment1_dir}/output.csv/* 2>/dev/null | head 

## Enter hdfs safemode
hdfs dfsadmin -safemode enter
