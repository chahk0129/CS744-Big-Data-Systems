from pyspark.sql import SparkSession
import sys

def simple_application(input_path, output_path):
    spark = (SparkSession
            .builder
            .appName("part2")
            .getOrCreate())
    df = spark.read.option("header", True).csv(input_path)
    df_sorted = df.sort(['cca2', 'timestamp'], ascending=[True, True])
    df_sorted.write.csv(output_path, header=True)


if __name__ == "__main__":
    print("Arguments", sys.argv)
    simple_application(sys.argv[1], sys.argv[2])


