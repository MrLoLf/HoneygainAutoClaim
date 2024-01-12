# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7528910118e022cfddfaf5e00b7bf9de4ecbb0bd7095df2f92b4ba158aee90f5 as builder

WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt --user

# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a90f92ba770d51f7e95c158d6ed1ac74ccc7332f9b42770d45a638fb1ac42844

WORKDIR /app

# Make sure you update Python version in path - has to be manually changed whenever Chainguard updates their Python package
COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages

COPY main.py .

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
