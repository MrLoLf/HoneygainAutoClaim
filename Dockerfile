# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1a8bc4369d7fd3832c05042526f5016d2f9ada8430c2edb7989b42283cb50305 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3938b12f0756715f6ee7c0a27dd9ef2763bcd2dfff2673c17761eaa3c2cb1b84

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
