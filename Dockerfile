# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ff2f023291872f7374ee8961e6f21b1ed6f0c54e8472ed96f09fd17c904d2dd6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d6f19033f93cb1ee292c2eee0daad3d3cbe8a1827fbe860686299e72647626b1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
