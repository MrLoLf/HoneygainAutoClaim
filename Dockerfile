# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:fb574b22d420dafeb4fae5336423fd71e227f33d8e5ff3131d6ecc48f4f75e15 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f5e8b018012c8767141cce3d14fd065bcbf20034239bd7f750a3d4cee49ce1d2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
