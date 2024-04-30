# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0c79e000c414e71638be888bc79d8602b4a724f90c5026f3a3fa6a96a07f5117 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f13535deeebbe11a52fd4ac763aebd6bfeb25a80b2344ccc9f405ac2ca344c35

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
