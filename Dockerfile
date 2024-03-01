# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d617cdb82a26c24042e5af1e4b5422a79c262c62bae17dead0ea1c5eefa0c66f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d974f608c981d3a1d40d5f842c6ad6fdfd9f8743f7a028c1c8d28a8154cad7cb

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
