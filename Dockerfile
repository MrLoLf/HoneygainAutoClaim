# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9d17a1a6abefdf74a71846181620e0434624af5dae791de10caad3f1ef1bb889 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:7cb75c899a7ce03356de6efc41e2242abfc00f92544a288131e13311547aadb0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
