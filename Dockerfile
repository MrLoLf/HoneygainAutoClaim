# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:92c4d83b4c0ab161ab1acee860fd1bb64502a525b6c156eed558da35140cf0ad as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .

# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a90f92ba770d51f7e95c158d6ed1ac74ccc7332f9b42770d45a638fb1ac42844

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

# Make sure you update Python version in path - has to be manually changed whenever Chainguard updates their Python pac>COPY --from=builder /home/nonroot/.local/lib/python3.12/site-packages /home/nonroot/.local/lib/python3.12/site-packages

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
