# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:78a6c1fee628bb02cd5ff637c7b08fdf441bba768f71a2caa2744cf7f41dc6bd as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8346471a731ba7a16f85d577179fc36b384b73edec8f323e97c94844881c7244

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
