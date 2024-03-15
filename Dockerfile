# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c26229dc2d26473042e47e337ee93bdcb09d0ad8184f681ced37d5d246f7f556 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:0492ec3eb9f43757c3a5d42198ea85fb61757700cd98436577a1924ec9d11c4e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
