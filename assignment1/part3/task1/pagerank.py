import re
import sys
from operator import add

from pyspark.sql import SparkSession

# This code mainly referred to https://github.com/apache/spark/blob/master/examples/src/main/python/pagerank.py

def compute_probs(pages, rank):
    num_pages = len(pages)
    for page in pages:
        yield (page, rank / num_pages)

def parse_neighbors(pages):
    neighbors = re.split(r'\s+', pages)
    return neighbors[0], neighbors[1]

def run_pagerank(input_path, num_iters=10):
    spark = (SparkSession.
            builder.
            appName("PageRank").
            getOrCreate())
    
    # Loads input files
    lines = spark.read.text(input_path).rdd.map(lambda r: r[0])



    # Read pages in input files and initialize their neighbors
    links = lines.map(lambda pages: parse_neighbors(pages)).distinct().groupByKey().cache()
    
    # Initialize ranks
    ranks = links.map(lambda page_neighbors: (page_neighbors[0], 1.0))

    # Calculates and updates page ranks up to num_iters
    for iteration in range(num_iters):
        # Calculates page contributions to the rank of other pages
        probs = links.join(ranks).flatMap(
                lambda page_pages_rank: compute_probs(page_pages_rank[1][0], page_pages_rank[1][1]))

        # Re-calculates page ranks based on neighbor contributions.
        ranks = probs.reduceByKey(add).mapValues(lambda rank: rank * 0.85 + 0.15)
        
    # Collects all page ranks and dump them to console.
    for (link, rank) in ranks.collect():
        print("%s has rank: %s." % (link, rank))

    spark.stop()

if __name__ == "__main__":
    # small dataset for test
    input_path = "hdfs://10.10.1.1:9000/user/hcha/assignment1/web-BerkStan.txt"
    # input_path = "hdfs://10.10.1.1:9000/user/hcha/assignment1/enwiki-pages-articles"

    run_pagerank(input_path)
   
