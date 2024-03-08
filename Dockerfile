# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:352705eb5ceda0b78a857c76f533a0b285c8273600c44862929d46fb0222c042 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:05c8eec91c19d8f1ba0c552b2844bb0413b3a467acf7adc93d2adc2e7a902d0f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
