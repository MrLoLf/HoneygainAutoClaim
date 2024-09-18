# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2511845fcd384226ef3eba33dfd9eb594b77d1a050387cd77062c24e5b1be251 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:68a0005cc572e765ea6dfac15d2cf05a6bbe40856210c1cbf0405aa472dbbbad

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
