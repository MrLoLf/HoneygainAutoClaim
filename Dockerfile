# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5e011b48d919b43dba2d821e7646f643eec568ab545ed5a2662d662e66e97e80 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c8c58449cd64727cfca03206b798ee9f3d64f8930273855db573538e023150a0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
