timestamp=`date "+%Y-%m-%d-%H%M%S"`
echo -n "Enter the dataset name ('web-BerkStan'|'enwiki-pages-articles') and press [ENTER]:"
read dataset_name

start_time="$(date -u +%s)"
spark-submit pagerank.py $dataset_name
end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"

echo $elapsed > "${dataset_name}_${timestamp}.log"

echo "Job done! ${elapsed} seconds elapsed..."
