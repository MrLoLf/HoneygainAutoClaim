# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:cf18a06fb2485556d8ea7f2070e7ca0e6710eeccb69321f8b413ca23677476c1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8eb266ac46896dd7cf17da76164517fe4eb252b33a12031f202054eac403f8bc

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
