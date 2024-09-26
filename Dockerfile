# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2faac6b5b2a6d56349e35ee4168f7210649eb3fe26ed2bc36c399f1bc81498fc as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3ede67268f05bae458bcc334155f72968a07ba681c7991df5eba75dfd6f7b94a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
