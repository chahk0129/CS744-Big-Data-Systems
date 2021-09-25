#!/bin/bash

## install spark
wget https://dlcdn.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
tar zvxf spark-3.1.2-bin-hadoop3.2.tgz

## set Worker IPs
echo "10.10.1.2" > spark-3.1.2-bin-hadoop3.2/conf/workers
echo "10.10.1.2" > spark-3.1.2-bin-hadoop3.2/conf/workers.template
echo "10.10.1.3" >> spark-3.1.2-bin-hadoop3.2/conf/workers
echo "10.10.1.3" >> spark-3.1.2-bin-hadoop3.2/conf/workers.template

## set spark local directory path
SPARK_LOCAL_DIR=/mnt/data/spark
echo "spark.local.dirs ${SPARK_LOCAL_DIR}" >> spark-3.1.2-bin-hadoop3.2/conf/spark-defaults.conf.template
echo "SPARK_LOCAL_DIRS=\"${SPARK_LOCAL_DIR}\"" >> spark-3.1.2-bin-hadoop3.2/conf/spark-env.sh.template
echo "export SPARK_LOCAL_DIRS=${SPARK_LOCAL_DIRS}" >> ~/.bashrc
source ~/.bashrc
