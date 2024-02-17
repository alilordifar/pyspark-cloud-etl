from pyspark.sql import SparkSession
# import just the necessary libraries to avoide any conflics
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark import SparkContext
import pandas as pd
import os
# Read airbvn data from Kaggle from the source system which is the on-premis system, produce them for the confluet kafka topic, process data, clean them, filter them, and then produced for the kafka topic, write error messages to S3 and valid data to S3
os.chdir('..')
if __name__ == '__main__':

    spark = SparkSession.builder \
        .appName("S3 Access") \
        .config('spark.hadoop.fs.s3a.aws.credentials.provider', 'org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider') \
        .getOrCreate()

    df = spark.read.format('csv') \
        .option('inferSchema', True) \
        .option('header', True) \
        .load('train.csv')
    df.show()
    df.printSchema()
    print(df.count())

    df.write.csv("s3a://testgenericetl/outpu.csv", mode="overwrite")
