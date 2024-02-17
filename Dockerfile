# Use an official Spark image as a parent image
FROM bitnami/spark

# Set the working directory in the container
WORKDIR /generic-cloud-etl

# Copy the current directory contents into the container at /app
ADD ./main/ /generic-cloud-etl/main/
ADD ./configs/ generic-cloud-etl/configs/
ADD ./data/ generic-cloud-etl/data/
ADD ./scripts/ generic-cloud-etl/scripts/
# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the Spark UI port
EXPOSE 4040