#!/bin/bash

## install spark
wget https://dlcdn.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
tar zvxf spark-3.1.2-bin-hadoop3.2.tgz

## set datanode IPs
echo "node1" > spark-3.1.2-bin-hadoop3.2/conf/workers
echo "node2" >> spark-3.1.2-bin-hadoop3.2/conf/workers
