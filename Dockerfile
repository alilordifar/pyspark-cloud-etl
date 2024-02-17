# Use an official Spark image as a parent image
FROM bitnami/spark

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app
RUN pip install pandas

# Expose the Spark UI port
EXPOSE 4040

# Run your application with Spark
#CMD ["/opt/bitnami/spark/bin/spark-submit", "--class", "org.apache.spark.examples.SparkPi", "/app/app.py"]
