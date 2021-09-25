# Assignment 1

## Building
1. HDFS
```bash
$ ./hdfs_config.sh
$ ./hdfs_run.sh
```
> `hdfs_config.sh` installs hadoop and sets necessary configurations (namenode, datanodes, etc.).
> `hdfs_run.sh` runs hadoop distributed filesystem.

2. Spark
```bash
$ ./spark_config.sh
$ ./spark_run.sh
```
> `spark_config.sh` installs spark and sets necessary configurations(workers, path to spark local directory, etc.).
> `spark_run.sh` runs spark on the distriubted cluster on top of hdfs.


## Dataset
```bash
$ ./install_dataset.sh
```
> `install_dataset.sh` fetches the datasets needed to run the spark applications. I.e., IoT data, Berkley-Stanford web graph.
We do not copy enwiki-pages-articles locally.
Instead we pass the absolute path of the dataset when running the application.


## Running
```bash
$ ./run_all.sh
```
> `run_all.sh` runs all the tests three times from part 2 to part 3 except for the last task in part 3.
> For the last task in part 3, we manually run the test and kill a worker based on the status of job execution by monitoring spark status page.


## Directories
> part2 includes a simple Spark application that sorts IoT dataset by the country code alphabetically (the third column) then by the timestamp (the last column).
> part3 includes Spark PageRank applications. 
They support Berkeley-Stanford web graph data, and enwiki-pages-articles data.
