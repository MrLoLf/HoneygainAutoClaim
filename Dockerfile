# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:6aa2c646af7e6b651f0090db08b00f44649bcc87eaaf3726be9a1fcb18e975a5 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c6718c5d43ab9e27a0e1c0aad6b12c01f992bebd9fb750366c44192d2621e37b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
