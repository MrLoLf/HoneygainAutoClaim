# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:557b79aed83c11cf2c5c92210d62c5cc4f6a3daf0b94513f0fac4921da5152ff as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:cdfa7a80d8781149d21fd790e1679232e286d5b2d21f54d511214764275d1632

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
