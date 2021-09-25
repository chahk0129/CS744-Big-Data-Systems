# Task 2
This task runs a PageRank algorithm with different number of partitions and executor memory sizes.

## How to run
```bash
$ ./run.sh [options] [num_partition] [memory_size in GB] [host_IP]
$ 	Options: 
$	    [input_name]: pass either web-BerkStan or enwiki-pages-articles
$	    [clear]: cleans up the output files written in hdfs directory
```
The script runs $pagerank_partition.py$ with two different datasets, i.e., web-BerkStan and enwiki-pages-articles.

## Evaluation
We evaluate the PageRank of two datasets with different number of partitions, and executor memory sizes.
We also measure the statistics of disk and network for namenode and each datanode to see the changes.
