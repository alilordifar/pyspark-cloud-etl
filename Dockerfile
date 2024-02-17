# Use an official Spark image as a parent image
FROM bitnami/spark

# Set the working directory in the container
WORKDIR /generic-cloud-etl

# Copy the current directory contents into the container at /generic-cloud-etl
COPY ./main/ /generic-cloud-etl/main/
COPY ./configs/ /generic-cloud-etl/configs/
COPY ./data/ /generic-cloud-etl/data/
COPY ./scripts/ /generic-cloud-etl/scripts/
COPY requirements.txt /generic-cloud-etl/

# Install any needed packages specified in requirements.txt
# Ensure pip is available. Bitnami Spark images might not have pip installed by default.
# Install any needed packages specified in requirements.txt
# Ensure pip is available. Bitnami Spark images might not have pip installed by default.
RUN pip install pyyaml pandas

# Expose the Spark UI port
EXPOSE 4040
