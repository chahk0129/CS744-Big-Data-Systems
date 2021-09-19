# Prepare datasets

Small dataset (web-BerkStan)
```
wget https://snap.stanford.edu/data/web-BerkStan.txt.gz
gzip -d web-BerkStan.txt.gz
hdfs dfs -put web-BerkStan.txt hdfs://10.10.1.1:9000/user/hcha/assignment1/web-BerkStan.txt
```

Large dataset (enwiki-pages-articles)
```
hdfs dfs -put /proj/uwmadison744-f21-PG0/data-part3/enwiki-pages-articles/ hdfs://10.10.1.1:9000/user/hcha/assignment1/enwiki-pages-articles
```
