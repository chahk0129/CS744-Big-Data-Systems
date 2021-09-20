#!/bin/bash
cur=$PWD

## update/install basic dependencies
sudo apt update
sudo apt install openjdk-8-jdk

## mount disk
sudo mkfs.ext4 /dev/xvda4
sudo mkdir -p /mnt/data
sudo mount /dev/xvda4 /mnt/data

## install hadoop
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
tar zvxf hadoop-3.2.2.tar.gz

## set hadoop path
hadoop_home=$(cur)/hadoop-3.2.2
echo "PATH=$(hadoop_home)/bin:$(hadoop_home)/sbin:\$PATH" >> ~/.profile
echo "export HADOOP_HOME=$(hadoop_home)" >> ~/.bashrc
echo "export PATH=\${PATH}:\${HADOOP_HOME}/bin:\${HADOOP_HOME}/sbin" >> ~/.bashrc
source ~/.profile
source ~/.bashrc

## set java path
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre" >> $(hadoop_home)/etc/hadoop/hadoop-env.sh

## set node info
echo "node1" > $(hadoop_home)/etc/hadoop/workers
echo "node2" >> $(hadoop_home)/etc/hadoop/workers
echo "node3" >> $(hadoop_home)/etc/hadoop/workers

## set namenode IP address
sed -i 's!<configuration>!<configuration>\n<property>\n<name>fs.default.name</name>\n<value>hdfs://10.10.1.1:9000</value>\n</property>!' $(hadoop_home)/etc/hadoop/core-site.xml;

## set data path for namenode
namenode_dir=hadoop-3.2.2/data
mkdir $(namenode_dir)
sed -i 's!<configuration>!<configuration>\n<property>\n<name>dfs.namenode.name.dir</name>\n<value>/users/hcha/'$namenode_dir'/</value>\n</property>\n<property>\n<name>dfs.datanode.data.dir</name>\n<value>/users/hcha/'$namenode_dir'/</value>\n</property>!' $(hadoop_home)/etc/hadoop/hdfs-site.xml;
