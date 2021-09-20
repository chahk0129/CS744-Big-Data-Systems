import time
import re
import sys
from operator import add
from pyspark.sql import SparkSession

def compute_probs(pages, rank):
    num_pages = len(pages)
    for page in pages:
        yield (page, rank / num_pages)

def parse_neighbors(pages):
    neighbors = re.split(r'\s+', pages)
    return neighbors[0], neighbors[1]

def run_pagerank(input_path, output_path, num_partitions=8, num_iters=10):
    spark = (SparkSession.
            builder.
            appName("PageRank").
            getOrCreate())
    
    # Load input files
    lines = spark.read.text(input_path).rdd.map(lambda r: r[0])

    # Read pages in input files and initialize their neighbors and set it to persist the dataframes
    links = lines.map(lambda pages: parse_neighbors(pages)).distinct().groupByKey().cache()
    
    # Repartition links
    links = links.repartition(num_partitions)

    # Initialize ranks
    ranks = links.map(lambda page_neighbors: (page_neighbors[0], 1.0)).repartition(num_partitions)

    # Calculate and update page ranks up to num_iters (default=10)
    for iteration in range(num_iters):
        # Calculate page contributions to the rank of other pages
        probs = links.join(ranks).flatMap(
                lambda page_pages_rank: compute_probs(page_pages_rank[1][0], page_pages_rank[1][1]))

        # Re-calculate page ranks based on neighbor contributions.
        ranks = probs.reduceByKey(add).mapValues(lambda rank: rank * 0.85 + 0.15).repartition(num_partitions)
        
    # Write output
    ranks.saveAsTextFile(output_path)

    spark.stop()

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: pagerank_cache.py <input> <output> <num_partitions>")
        sys.exit(-1)

    #if sys.argv[1] == 'web-BerkStan':    
        # small dataset for test
    #    input_path = "hdfs://10.10.1.1:9000/user/hcha/assignment1/web-BerkStan.txt"
    #elif sys.argv[1] =='enwiki-pages-articles':
    #    input_path = "hdfs://10.10.1.1:9000/user/hcha/assignment1/enwiki-pages-articles"
    #else:
    #    print("Usage: pagerank.py <file> <num_partitions>, where <file>:='web-BerkStan'|'enwiki-pages-articles'", file=sys.stderr)
    #    sys.exit(-1)
    num_partitions = sys.argv[3]
    start = time.time()
    run_pagerank(sys.argv[1], sys.argv[2], num_partitions=int(num_partitions))
    end = time.time()
    print("------------------------------")
    print("Elapsed time: " + str(end - start) + " sec")
    print("------------------------------")
