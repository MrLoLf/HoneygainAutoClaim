# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:63658227c7ab7721234bf0885232eb11300d2e6693e08f9e78289c8bd9b089a1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:73d190f98ad153222ec562056fd8afd710b0d513d6015672e6198046978942f3

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
