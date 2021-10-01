#!/bin/bash

sudo apt update

## install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc

## install numpy
conda install numpy

## install pytorch
conda install pythorch torchvision torchaudio cpuonly -c pytorch
