from pyspark.sql import SparkSession
import sys

def simple_application(input_path, output_path):
    # initialize spark sql instance
    spark = (SparkSession
            .builder
            .appName("part2")
            .getOrCreate())

    # load input data
    df = spark.read.option("header", True).csv(input_path)

    # sort the input data firstly by country code and then by timetstamp
    df_sorted = df.sort(['cca2', 'timestamp'], ascending=[True, True])

    # write output
    df_sorted.coalesce(1).write.mode('overwrite').option('header','true').csv(output_path)


if __name__ == "__main__":
    print("Arguments", sys.argv)
    simple_application(sys.argv[1], sys.argv[2])


