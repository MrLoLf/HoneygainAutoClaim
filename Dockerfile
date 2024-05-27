# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:70f97dd84e4f7f3962ee3dc46b0c206f583981ea3317bfb7faca3d6082d4d41e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:99ee1559c4632e06f293a2f03a2677e6bff371d37b4de6e21322715cb0697055

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
