#!/bin/bash
#set -x
# Count thenuber of arguments. If it is not equal to one then EXIT, else CONTINUE
if [[ "$#" -ne 1 ]]; then
     echo "Usage: ./<<program_name>>.sh <<CONFIG_FILE>>"
     echo "Example: ./run-generic-etl.sh config.yaml"
     exit
fi

# Read the Environment variable
config_file=$1
exec_date=$(date + '%Y-%m-%d')

# app properties
properties="/generic-cloud-etl/scripts/app.properties"

# Check app.properties
echo "Loading the Properties File. File path is "${properties}

if [ -f "${properties}" ]; then
  echo "Properties file path is correct. Loading variables..."
else
  echo "Properties file does not exists. Terminating."
  exit
fi

# Read the value from app.properties
DT=$(date + '%Y%m%d-%H%M%S')
DATE=$(date +%Y-%m-%d)
FILENAME="${config_file}-${DT}"
base_location=$(grep -i base_location ${properties} | cut -d '=' -f2- | tr -d '\r')
s3_acess_key=$(grep -i s3_access_key ${properties} | cut -d '=' -f2- | tr -d '\r')
s3_secret_key=$(grep -i s3_secret_key ${properties} | cut -d '=' -f2- | tr -d '\r')

export config_path=${base_location}/configs/${config_file}
export access_key=${s3_access_key}
export secret_key=${s3_secret_key}

echo "spark-submit..."

spark-submit \
--name ${config_file} \
--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem \
--conf spark.hadoop.fs.s3a.path.style.access=true \
--conf spark.hadoop.fs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider \
--conf spark.hadoop.fs.s3a.access.key=${access_key} \
--conf spark.hadoop.fs.s3a.secret.key=${secret_key} \
--files ${config_path} \
${base_location}/main/generic-etl.py --config ${config_file}