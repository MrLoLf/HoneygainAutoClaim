# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5b4203b3f6bd2fb9bf781c25f4ebaba7e61be425c2d953c4bb729a47d63e794e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a8cc6a296daaa162d60d09b3ebf33a5766e31c17c815a05eb1837094a738b8ee

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
