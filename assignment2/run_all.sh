#!/bin/bash

cur=$PWD

## run part1
cd part1
./run.sh

## run part2
cd $cur/part2/taskA
./run.sh
cd $cur/part2/taskB
./run.sh

## run part3
cd $cur/part3
./run.sh
