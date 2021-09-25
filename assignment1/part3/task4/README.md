# Task 4
This task runs a PageRank algorithm with different number of partitions and executor memory sizes with caching intermediate data.
It is designed to see the effects of a worker process kill during the execution.

## How to run
```bash
$ ./run.sh [options] [num_partition] [memory_size in GB]
$ 	Options: 
$	    [input_name]: pass either web-BerkStan or enwiki-pages-articles
$	    [clear]: cleans up the output files written in hdfs directory
```
The script runs $pagerank_cache.py$ with two different datasets, i.e., web-BerkStan and enwiki-pages-articles.

## Evaluation
We evaluate the PageRank of two datasets with different number of partitions, and executor memory sizes with caching enabled.
We also measure the statistics of disk and network for namenode and each datanode to see the changes.
We manually kill a worker process based on the status of job execution (25% and 75%) by monitoring the Spark status.
