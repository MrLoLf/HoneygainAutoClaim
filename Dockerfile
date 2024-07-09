# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:52a8493b8f1fb397872fbda1bb731cd1cfdbd05b6c66c1923e3af86c475a848d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8ffe47b9158f5908ebaad5bba092913ca8de8ea3df6b5caefb8818629cc5b5f1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
