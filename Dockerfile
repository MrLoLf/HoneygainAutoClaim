# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:010b4e6585fead08523213078019cad1c196f005b9b4d64d558397d5ee211825 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e94bec761ec11f0a316faad77b795837ebd81f37b0c9f2ea59cadd4644e15087

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
