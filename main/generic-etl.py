from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark import SparkContext
from pyspark.broadcast import Broadcast
import pandas as pd
import os
import logging
import argparse
import yaml

# Read airbvn data from Kaggle from the source system which is the on-premis system, produce them for the confluet kafka topic, process data, clean them, filter them, and then produced for the kafka topic, write error messages to S3 and valid data to S3
#os.chdir('..')

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
_logger = logging.getLogger(__name__)

parser = argparse.ArgumentParser(description="Gneric-Cloud-ETL")
parser.add_argument('--config', required=True, help='YAML file containing configurations')

args = vars(parser.parse_args())

config = args['config']

with open(config, 'r') as stream:
    try:
        config = yaml.safe_load(stream)
        print(config)
    except yaml.YAMLError as exc:
        _logger.info(exc)

sc = SparkContext()
spark = SparkSession(sc)

bc_config = sc.broadcast(config)

source_path = f"{bc_config.value['source']['source_path']}"
print(source_path)
source_format = f"{bc_config.value['source']['source_format']}"
print(source_format)
target_path = f"{bc_config.value['target']['target_path']}"
print(target_path)

def start_job():
    df = spark.read.format(f'{source_format}') \
        .option('inferSchema', True) \
        .option('header', True) \
        .load(f'{source_path}')
    df.show()
    df.printSchema()
    print(df.count())

    df.write.csv("s3a://testgenericetl/", mode="overwrite")


if __name__ == '__main__':
    _logger.info(spark.sparkContext.getConf().getAll())
    applicationId = spark.sparkContext.applicationId
    try:
        start_job()
    except Exception as e:
        _logger.info(str(e))
        sys.exit(1)
    finally:
        spark.stop()
