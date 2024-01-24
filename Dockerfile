# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:da4250ea0b2c296f8520c90ffa3e7b12e634d94b9eb50021100e9b660749c0a4 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:0d2d388c31746f7ad6c8563d32c3929b39a8f2487a666d05a7c8095dfac0b125

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
