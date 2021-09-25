#!/bin/bash

## dataset for part2
cd part2
wget http://pages.cs.wisc.edu/~shivaram/cs744-fa18/assets/export.csv

## datasets for part3
cd ../part3
wget https://snap.stanford.edu/data/web-BerkStan.txt.gz
gzip -d web-BerkStan.txt.gz
# we do not copy the enwiki data to local. Instead, we use it directly by passing the absolute path
#cp -r /proj/uwmadison744-f21-PG0/data-part3/enwiki-pages-articles .
