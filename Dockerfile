# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:03b630216f9fa76a0dedc4e7f6f40bea22b2fd56e32a625227d8135e9256c2da as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:11857e623e3869769d46f875533358a4658c6e08263cc9dafc32711a4a36c8c7

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
