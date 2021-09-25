# Part 2

## How to run
```bash
$ ./run.sh $HOST_IP
```
> `$ ./run.sh` runs `part2_simple.py` application which sorts the `export.csv` data, and stores the ouptut in hdfs.
> When running, we first create appropriate directory paths.
After, adding the local input file (i.e., `export.csv`) to hdfs, we validate the copy via reading the first 10 lines of the input in hdfs.
Then, we run the application, and also check if the output file has been correctly written in hdfs by reading the first 10 lines of the output.
> `$ ./run.sh clear`cleans up the input and output in hdfs stored during the previous execution.


## Application Detail
> We simply initialize spark sql instance, load input data, sort it firstly by country code and then by timestamp, and write the output.
