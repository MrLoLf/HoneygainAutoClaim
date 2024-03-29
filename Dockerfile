# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d56eb91964f17391ab9933079f89d6d2cd7b5bf5c2d10e1a33b2208c130da77f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3559f62cb6e38925fb97b9479612522abb4522c95b80e65e7f50e9e4a67cc0d9

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
