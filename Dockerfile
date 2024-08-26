# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5bfd5ab3ab46014154dd7b118338fd4a7a2acf8943eb3eca4af1e91ce6a36a9f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d3dd679ddd2cc6ad2452024b5f9760f4c009e2e6628776105e71f4501b52be05

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
