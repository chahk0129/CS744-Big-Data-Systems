# Assignment 2

## Building
1. Miniconda
```bash
$ ./config.sh
```
> `config.sh` installs miniconda, numpy and pytorch 

## Running
```bash
$ ./run_all.sh
```
> `run_all.sh` runs all the tests including part 1, 2 and 3.


## Directories
> part1 includes a model setup and tranining setup to train on VGG-11 network with Cifar10 dataset.<br/>
> part2 includes two versions of distributed data parallel training, one that synchronizes gradients with gather and scatter, and the other synchronizes gradients with allreduce.<br/>
> part3 includes distributed data parallel training that uses the gradient synchronization approach in Pytorch.
