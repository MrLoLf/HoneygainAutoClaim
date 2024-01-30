# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:dbf2c1439f044615c50218bf7ab8414fb39288f89dd9f38b35ebe4c8a2a951da as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4cd9986c4e8c6c5f091a46f38f19b212e0f46a21e8e6e540596f266a123781c2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
