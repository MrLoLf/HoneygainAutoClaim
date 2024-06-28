# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:78c327ed9c3bb20fcef2226452b67c5071b03e51de35048acce21e4ae319e614 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9c774781fbaf008bbf43eeae6fd3aef61aed210b11033415a0fd635d4c684633

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
