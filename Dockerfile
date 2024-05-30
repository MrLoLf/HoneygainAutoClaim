# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:f7f6bb2206231aeaeb047d42747ae3d08a102fbcd5b1b9bb8e5809ad34562970 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b6f495ed363328b0600c5b9b8cbf5e76c4bb981a7641988722123024a97b41b6

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
