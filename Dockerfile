# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:644de8cd529d28af198e476ce9949f365d5002301f4ccb02a895bfe8fa49439f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d18bb6ba80da7dc894bbb40c438caf37187a2efbbba8560e691e577d8711e778

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
