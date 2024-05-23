# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:63f5250460eb0493fa7a676acd2405b1a8ae7a68c2fff20b477418daed6442b0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b9b3c8028e61f616a06f9fe2a9fefd491ae6bf1d1ffebd5aa9c7690bbd9499cf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
