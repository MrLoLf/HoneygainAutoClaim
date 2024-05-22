# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:fe6862ec302fd71288cba4bc636454fe160859f615d0d207d73dd76128ad6744 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:fcabd6b5ea4a1f20a2451791d4c5db3aacb9f5a097275ba2a90722aa9f0cd9bf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
