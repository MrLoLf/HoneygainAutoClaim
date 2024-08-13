# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:db08a948d1416730c8d5602f1f31af120a72ff629cc06cf17058aeed6e1be4f1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:02c24c3874435cd6ef510e8231eb461f38c9c1e432d2296513f412b65681d511

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
