# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:82d3cb0ac313ff5f609ca52eb52e05903f723425293187b3b02e03c614507406 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8c17b4bb6bb24bdc071e316746f293477f9b9bf2deb46bfef340efcbc2fdf5cf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
