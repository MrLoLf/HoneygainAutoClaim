# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:bf1e70106bb48aac361539f368d0ca578f699c1e5b7a2c6368c30e5a64a7e956 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6149c997ef1816ef8acb0f5ba91d7e9253d3ed69f47209e57d85169dee583d00

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
