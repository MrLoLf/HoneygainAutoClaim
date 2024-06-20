# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:8a5b1f0314ae05f1161cd97e4191bf2e176f78a837bf2e356bcf63ed1584dd84 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:944f0e85bf1ba7b20d2755b9be05b5cb155aa8624c11cfae2126786428343202

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
