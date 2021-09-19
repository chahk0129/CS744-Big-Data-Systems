timestamp=`date "+%Y-%m-%d-%H%M%S"`
echo -n "Enter the dataset name ('web-BerkStan'|'enwiki-pages-articles') and press [ENTER]:"
read dataset_name
echo -n "Enter the number of partitions and press [ENTER]:"
read num_partitions

start_time="$(date -u +%s)"
spark-submit pagerank_cache.py $dataset_name $num_partitions
end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"

echo $elapsed > "${dataset_name}_${num_partitions}_${timestamp}.log"

echo "Job done! ${elapsed} seconds elapsed..."
