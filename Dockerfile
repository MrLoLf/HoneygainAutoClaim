# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5727408976bf17a1f034ead1bb6f9c145b392e3ffb4246c7e557680dc345f6ff as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a66be254adc25216a93a381b868d8ca68c0b56f489cd9c0d50d9707b49a8a0a4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
