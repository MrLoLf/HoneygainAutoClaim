# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:953c61788842a0f2be9bc2e6acf3c56d0c9f48fe01bdb12402d27fab3b0a25cf as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9ba66cab5047b59445be7d413af06d68edf2d7ad26f9f4b2277f37f3229f429c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
