### Make folders for assignment 1
```
hadoop fs -mkdir hdfs://10.10.1.1:9000/user
hadoop fs -mkdir hdfs://10.10.1.1:9000/user/hcha
hadoop fs -mkdir hdfs://10.10.1.1:9000/user/hcha/assignment1
```

### Add local file (export.csv) to hdfs
```
hdfs dfs -put export.csv hdfs://10.10.1.1:9000/user/hcha/assignment1/export.csv
```

### Check hdfs file
```
hdfs dfs -cat hdfs://10.10.1.1:9000/user/hcha/assignment1/export.csv 2>/dev/null | head
```

### Run simple application
```
./run.sh
Enter the input path and press [ENTER]:hdfs://10.10.1.1:9000/user/hcha/assignment1/export.csv
Enter the output path and press [ENTER]:hdfs://10.10.1.1:9000/user/hcha/assignment1/output.csv
```

### Check output file (10 lines)
```
hdfs dfs -cat hdfs://10.10.1.1:9000/user/hcha/assignment1/output.csv/* 2>/dev/null | hea
```

### Clear output file
```
hdfs dfs -rm -r hdfs://10.10.1.1:9000/user/hcha/assignment1/output.csv
```
