# Part 3

## How to run
```bash
$ ./run.sh
```
> `run.sh` runs the application with different number of nodes.<br/>
> We note that the script needs to be run on only the master node, as we create daemon processes that trigger joins of remote applications in each run.<br/>
> Statistics of each node are stored in its local directory as we do not want network bandwidth and CPU consumption for the transmission.
