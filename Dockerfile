# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5f367a60f8328ca2c744664ffb2d8ee35377b9203f62d397d7d1cf81cb0c8039 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6258780e38cfdf5d543ef0c95f9723d88361351d67c972b7ac3343621a27c499

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
