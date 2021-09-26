#!/bin/bash

## install spark
wget https://dlcdn.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
tar zvxf spark-3.1.2-bin-hadoop3.2.tgz

## set Worker IPs
echo "10.10.1.2" > spark-3.1.2-bin-hadoop3.2/conf/workers.template
echo "10.10.1.3" >> spark-3.1.2-bin-hadoop3.2/conf/workers.template

## set spark local directory path
SPARK_CONF_DIR=spark-3.1.2-bin-hadoop3.2/conf
SPARK_LOCAL_DIR=/mnt/data/spark
HDFS_LOCAL_DIR=/mnt/data/hdfs
echo "spark.local.dirs ${SPARK_LOCAL_DIR}" >> ${SPARK_CONF_DIR}/spark-defaults.conf.template
echo "SPARK_LOCAL_DIRS=\"${SPARK_LOCAL_DIR}\"" >> ${SPARK_CONF_DIR}/spark-env.sh.template
echo "SPARK_PID_DIR=\"${SPARK_LOCAL_DIR}" >> ${SPARK_CONF_DIR}/spark-env.sh.template
echo "export SPARK_LOCAL_DIRS" >> ${SPARK_CONF_DIR}/spark-env.sh.template
echo "export SPARK_PID_DIR" >> ${SPARK_CONF_DIR}/spark-env.sh.template
echo "SPARK_JAVA_OPTS+=\" -Dspark.local.dir=${SPARK_LOCAL_DIR} -Dhadoop.tmp.dir=${HDFS_LOCAL_DIR}" >> ${SPARK_CONF_DIR}/spark-env.sh.template
echo "export SPARK_JAVA_OPTS" >> ${SPARK_CONF_DIR}/spark-env.sh.template
mv ${SPARK_CONF_DIR}/spark-env.sh.template ${SPARK_CONF_DIR}/spark-env.sh
sh ${SPARK_CONF_DIR}/spark-env.sh

echo "export SPARK_LOCAL_DIRS=${SPARK_LOCAL_DIR}" >> ~/.bashrc
source ~/.bashrc
