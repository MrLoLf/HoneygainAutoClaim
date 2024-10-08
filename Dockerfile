# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:40b76be74c72e7803505dde2c239443ae3aa4946a98d63668e82e61b5bc80464 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2fb6c1fcd0ee933b44628db6a9a5084faa686fec76041b852ac1680415a2fdc0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
