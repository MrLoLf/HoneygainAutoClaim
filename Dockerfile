FROM python:3.13.0a2-slim

WORKDIR /app

# Copy every file from the local directory to the container's working directory
COPY ./* /app/

# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt

# Set the working directory to the /app directory
WORKDIR /app

# Run the main script using Python
CMD ["python", "main.py"]
