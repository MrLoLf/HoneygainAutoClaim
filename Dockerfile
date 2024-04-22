# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e711f60f7e49f377b1f99be309b21fb4a6c247d5cc10badc231cb82240965ac9 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5048e0f5ef4cea6086790b1aa415553b80b3857f3a0c15326e8ad51a13d55ce4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
