# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:56051158a26addb1b4bd236c99a4dd1405e3afa54056d665438700566534aa91 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a7c5dbd20f20aaa49cbb5c2b680b027aa66c9e754da8f90d2c9718976e3acc6a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
