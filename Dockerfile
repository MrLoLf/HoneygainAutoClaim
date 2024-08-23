# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2eeec3f6435453b8743db00bfede38f81e3160772456468e6521a3dffa56c1f4 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8e1d8d13a046fbcab6ac1f68a0887d737d96c4355aab8e3d3031671a465ee047

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
