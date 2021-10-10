#!/bin/bash

cur=$PWD

## run part1
cd part1
./run_full.sh

## run part2
cd $cur/part2/taskA
./run_full.sh
cd $cur/part2/taskB
./run_full.sh

## run part3
cd $cur/part3
./run_full.sh
