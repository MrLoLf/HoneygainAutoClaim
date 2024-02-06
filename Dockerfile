# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1b1749d66fce220cb4cb268dd9a7dad2c314abce87158869b491774c292f5ad9 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4a1b3941e0c451a453637a7aef9db386772e6a8b2262135f7f2c43bb3fd085f2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
