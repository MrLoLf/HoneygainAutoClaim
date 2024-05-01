# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:59370b0adb1cb6c95e8bbc5f10e2f2614be2cb7b5ef3072d1c18f62f5bed60ce as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f3c4aadce2bd015ec36a777eface9389cb5cf8a0656bd85d7a9b8ce1cfbfac1e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
