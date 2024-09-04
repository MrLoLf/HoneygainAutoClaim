# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:da16a852e53e8f2ad0f7b96812e1598d36635c086e7d3883fbde1f9f249b75b8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8f69b7d33a65d7b3833797301e0f94f95b0dc16662c3e22d7d1db9c8ebbf9c8d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
