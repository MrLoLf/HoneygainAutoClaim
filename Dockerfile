# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a9c0273275534943c3943292dcd237fed71f9ce1754a55f555c98606559e8756 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:df995ee70875bcaa0c702bcb3be270df17fac9cbf1316d26bd0c42b907cb508f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
