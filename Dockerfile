# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:6e3444c5ce7069cc02cf266ba0acde7ee436edfecc1d6767d69528a12af3dbaf as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9e1f35b5aac96317bb15c2102d80964b9e6151fcae2662094d4871c87d1c3cfd

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
