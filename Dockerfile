# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1317aa66fec4b9735101d38df69c9fc1cc1e8e045ec1d11ddaa2e976005e2b60 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:87bd6a67a50c5aa1f9b03b38d1c914594248310778d0e055c48c9cb00613cb06

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
