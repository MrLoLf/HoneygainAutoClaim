# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:628cdda3c986b81162a8bc06fd3ad1c9213d88bf7c1f16267736b598a4a20520 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8ab7150acbdfc4dc445503a67c7f69af2eeba6a9b476fb669bb5b2163826ac5a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
