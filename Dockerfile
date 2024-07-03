# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b179fd2b12dadbc3fceb0fda5133020269da349083eef7d1a6378a338fa4ee4b as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:32641d8d211e717a0e83b3d69f7e9eff78646d735c826fee8b46f4420ff7f155

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
