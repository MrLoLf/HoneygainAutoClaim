# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:40b3a19b7e2a50824b1ff32d61ae5f59af1b0de67f7bb8e56f5804bace0d94b7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5f16431f56f330925a9c8f5168b31ca65f603de15b127b376f8532bab11583c0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
