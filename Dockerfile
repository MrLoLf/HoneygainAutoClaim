# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:fd845b48e52dd2925b1f2df375520706319189a88f574df02c284205e4af2754 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:7ae818a3d32ecc4c747637a7c2baba5f6e0ba75b2d0ceb6744c3fb0ca8d208d1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
