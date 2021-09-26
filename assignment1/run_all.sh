#!/bin/bash

## get ip address of namenode
ip_addr=$(hostname -I)
ip=(${ip_addr//" "/ })

## run part2
cd part2
./run.sh $ip
./run.sh clear



## run part3
cd ../part3
dataset="web-BerkStan enwiki-pages-articles"
partition="1 2 4 8 16 32 64 128 256"
default_partition=32
max_memory=30
memory="1 5 10 15 20 25 30"


## task1 -- measure breakdown of pagerank execution
cd task1
for dat in $dataset; do
	./run.sh $dat $ip
	./run.sh clear
done


## task2-1 -- test performance with different number of partitions (fixed mem, i.e., 30GB)
cd ../task2
for dat in $dataset; do
	for part in $partition; do
		./run.sh $dat $part $max_memory $ip
		./run.sh clear
	done
done

## task2-2 -- test performance with different memory sizes
for dat in $datset; do
	for mem in $memory; do
		./run.sh $dat $default_partition $mem $ip
		./run.sh clear
	done
done


## task3-1 -- test performance with different number of partitions (fixed mem, i.e., 30GB)
cd ../task3
for dat in $dataset; do
	for partitions in 1 2 4 8 16 32 64 128 256; do
		./run.sh $dat $partitions $max_mem $ip
		./run.sh clear
	done
done

## task3-2 -- test performance with different memory sizes
for dat in $datset; do
	for mem in $mem; do
		./run.sh $dat $default_partition $mem $ip
		./run.sh clear
	done
done

## task4 -- we kill the process manually by monitoring the status of job execution 
