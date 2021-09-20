#!/bin/bash

if [[ "$@" = *--help ]] || [[ "$@" = *-h ]]; then
	echo "Usage: ./run.sh [options]"
	echo -e "\t[empty]: runs simple sort application"
	echo -e "\t[clear]: cleans up the output in hdfs directory"
	exit 1
fi

## Clean up resources
if [  "$1" = "clear" ]; then
	hdfs dfsadmin -safemode leave 
	hdfs dfs -rm -r ${namenode_dir}/user/hcha/assignment1/output.csv
	hdfs dfsadmin -safemode enter
	exit 1
fi


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

## Run the simple application (sort)
spark-submit part2_simple.py ${assignment1_dir}/export.csv ${assignment1_dir}/output.csv

## Enter hdfs safemode
hdfs dfsadmin -safemode enter

## Read output file
hdfs dfs -cat ${assignment1_dir}/output.csv/*
