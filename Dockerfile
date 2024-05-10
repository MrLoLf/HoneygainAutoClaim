# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:237d873a449fe2fe4859c13f56b170ba739b0f5c0422f4e139499ecf044f415c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f910d00bf6accfa0641eb8220a674d0d2927edbe5b0f5c096fe725cb1b905a60

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
