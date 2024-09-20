# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e4453f844869a2f510d464471440293e4cb9517f7f861b5f90dd649e41b12e31 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:72d500b1974e2081b2b10f4737b5b7307298810b288fc645b531eaa0f8c86672

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
