# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7af0b89d0dea414f33dd1db87a3942744108d73648f8902af09948baa35baac1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a640f1a266988d5a44bc75c15fdd34892183b4019550f8d66aa9e3c885018658

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
