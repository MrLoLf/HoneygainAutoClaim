# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:67590fa0aa47e926db2bb248dc70de6c2265debcef62cbd320601881ddbfc49a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:56538572bc98e93976692e3dcfe984352bd7c72eef32b3947730c0b3a43ca802

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
