# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2ad42bda7fe146e3f717aaa1d8ecd0f178aa5450898d52b33c52ea1714df5aa6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9e1f35b5aac96317bb15c2102d80964b9e6151fcae2662094d4871c87d1c3cfd

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
