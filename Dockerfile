# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e0eb8839878747f72e463443c468f2fff20265ce54675d21030fe011fab74256 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f56ca42f01f2ee931b18089b454be74ddaf72098aa5e06554ce60086b020b9b1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
