# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0f0edc7e39762dbb0d92fb1152621c3215c5d40f290aa09309031dddb5e6102f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3c4aa998b280d055537c15120335a9eba76b62f4525454518076b6861cfe788d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
