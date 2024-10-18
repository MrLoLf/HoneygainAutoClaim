# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:cc6f7a1e53f7c803f2ec8013eedb89a35f61e23de44b067661f8a317f93e423e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c73e2dcefb8e97860ab0c0b374758df9b4938f023b56a1298526a645f6e6be51

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
