# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a66967d781bec4367589c4e9b98c18e3df0f24c38c380e45af383a3424b34bde as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6a7100769a082ca01772e302b6fce08a28ea4225bb73fbf1e00dbc0147f79900

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
