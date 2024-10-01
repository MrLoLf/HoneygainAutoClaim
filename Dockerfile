# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:01fdc24792d1958e088b524afc3d7c8f9281b22b357f3b074737807cccec8d03 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c2f8ee7598d9d959c475428705477e08e199666b6460692b1f0bcb198c1c0676

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
