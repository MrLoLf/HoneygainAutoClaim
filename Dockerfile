# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:af9d618ad0994f19fd93fd9d0096a91c783a2b97883c6add72c89cf81555e048 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fc921903ce0904ef1a0b4e0b442a94d3de1a361999970517679da3382e7dc7d2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
