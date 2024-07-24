# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:39d3b461ec14222f7eadb6cf5c64153291c03aca514e09b307b77aa60d0f0a3b as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5b0aef78beea1a889c0f656b46009ffc63214f06014ec51df7a219d78cd961dc

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
