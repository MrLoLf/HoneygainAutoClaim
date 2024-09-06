# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4d6f418a5dfad7bb4dd2641b5498d3aa53708073c0e1909fde19cf3568c8aa59 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f7b840c6b5b3144359e7801ad00ecb5483acd7d6957aaf34b4ecdcaed3532c52

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
