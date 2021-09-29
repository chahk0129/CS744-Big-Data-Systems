# Task 1
This task runs a PageRank algorithm with default settings.

## How to run
```bash
$ ./run.sh [options] [host_IP]
$ 	Options: 
$	    [input_name]: pass either web-BerkStan or enwiki-pages-articles
$	    [clear]: cleans up the output files written in hdfs directory
```
> The script runs `pagerank.py` with two different datasets, i.e., web-BerkStan and enwiki-pages-articles.

## Evaluation
> We measure the execution times in breakdown with 5 categories, initialization, data read, computation, data write, and resource cleanup.
We also measure the statistics of disk and network for namenode and each datanode to see the changes.
