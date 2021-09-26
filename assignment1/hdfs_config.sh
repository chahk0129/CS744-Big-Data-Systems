#!/bin/bash
cur=$PWD

## update/install basic dependencies
sudo apt update
sudo apt install openjdk-8-jdk

## mount disk
hadoop_data_path=/mnt/data/hdfs
spark_data_path=/mnt/data/spark
sudo mkfs.ext4 /dev/xvda4
sudo mkdir -p /mnt/data
sudo mount /dev/xvda4 /mnt/data
sudo mkdir ${hadoop_data_path} ${hadoop_data_path}/datanode ${hadoop_data_path}/namenode
sudo mkdir ${spark_data_path} ${spark_data_path}/logs
sudo chown -R hcha /mnt/data
sudo chmod -R 777 /mnt/data

## install hadoop
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
tar zvxf hadoop-3.2.2.tar.gz

## set hadoop path
hadoop_home=${cur}/hadoop-3.2.2
echo "PATH=$(hadoop_home)/bin:${hadoop_home}/sbin:\$PATH" >> ~/.profile
echo "export HADOOP_HOME=${hadoop_home}" >> ~/.bashrc
echo "export PATH=\${PATH}:\${HADOOP_HOME}/bin:\${HADOOP_HOME}/sbin" >> ~/.bashrc
source ~/.profile
source ~/.bashrc

## set java path
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre" >> ${hadoop_home}/etc/hadoop/hadoop-env.sh

## set node info
echo "10.10.1.2" > ${hadoop_home}/etc/hadoop/workers
echo "10.10.1.3" >> ${hadoop_home}/etc/hadoop/workers

## set namenode IP address
sed -i 's!<configuration>!<configuration>\n<property>\n<name>fs.default.name</name>\n<value>hdfs://10.10.1.1:9000</value>\n</property>!' $(hadoop_home)/etc/hadoop/core-site.xml;

## set data path for namenode and datanodes
namenode_dir=${hadoop_data_path}/namenode
datanode_dir=${hadoop_data_path}/datanode
sed -i 's!<configuration>!<configuration>\n<property>\n<name>dfs.namenode.name.dir</name>\n<value>/users/hcha/'$namenode_dir'/</value>\n</property>\n<property>\n<name>dfs.datanode.data.dir</name>\n<value>/users/hcha/'$datanode_dir'/</value>\n</property>!' $(hadoop_home)/etc/hadoop/hdfs-site.xml;
