import time
import re
import sys
from operator import add

from pyspark.sql import SparkSession

# This code mainly referred to https://github.com/apache/spark/blob/master/examples/src/main/python/pagerank.py

def compute_probs(pages, rank):
    num_pages = len(pages)
    for page in pages:
        yield (page, rank / num_pages)

def parse_neighbors(pages, input_path):
    if 'web' in input_path: # web-BerkStan
        neighbors = re.split(r'\s+', pages)
    else: # enwiki
        neighbors = re.split(r'\t+', pages) 
    
    return neighbors[0], neighbors[1]

def run_pagerank(input_path, output_path, num_iters=10):
    init_start = time.time()
    spark = (SparkSession.
            builder.
            appName("PageRank").
            getOrCreate())
    init_end = time.time()

    # Loads input files
    lines = spark.read.text(input_path).rdd.map(lambda r: r[0])

    # Read pages in input files and initialize their neighbors
    links = lines.map(lambda pages: parse_neighbors(pages, input_path)).distinct().groupByKey()
    
    # Initialize ranks
    ranks = links.map(lambda page_neighbors: (page_neighbors[0], 1.0))
    read_end = time.time()

    # Calculates and updates page ranks up to num_iters
    for iteration in range(num_iters):
        # Calculates page contributions to the rank of other pages
        probs = links.join(ranks).flatMap(
                lambda page_pages_rank: compute_probs(page_pages_rank[1][0], page_pages_rank[1][1]))

        # Re-calculates page ranks based on neighbor contributions.
        ranks = probs.reduceByKey(add).mapValues(lambda rank: rank * 0.85 + 0.15)
    compute_end = time.time()
        
    # Write output
    ranks.saveAsTextFile(output_path)
    write_end = time.time()
    spark.stop()
    end = time.time()
    print("----------------------------------")
    print("Init time: " + str(init_end - init_start) + " sec")
    print("Read time: " + str(read_end - init_end) + " sec")
    print("Compute time: " + str(compute_end - read_end) + " sec")
    print("Write time: " + str(write_end - compute_end) + " sec")
    print("Resource cleanup time: " + str(end - write_end) + " sec")
    print("Total elapsed time: " + str(end - init_start) + " sec")
    print("----------------------------------")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: pagerank.py <input> <output>")
        sys.exit(-1)

    run_pagerank(sys.argv[1], sys.argv[2])
