# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:370b677f44814fe8dda63e9bb407af8fbd1fc147176808f0e5576100f67dbf73 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c938906238f844b80d0783f4d8bcb700bf8c644d647f95b2adeddaa15fa63156

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
