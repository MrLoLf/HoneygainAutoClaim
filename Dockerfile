# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4968705def11dd6a55b24975611b3e52d502faea31711fae6e297c3741c57a99 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:cfba883e4a91151c0ca0c18ec142d61eaee55d64bd489f13a0a4274dff425d93

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
