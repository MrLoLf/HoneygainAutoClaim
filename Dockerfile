# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1926972c570b406c72b958cb1401f037c78b83d24421fda069eab03ce4654987 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8fddee16558b827a5c77acfc4a52940aeec9ea889600cc92f642d6eee11fb7eb

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
