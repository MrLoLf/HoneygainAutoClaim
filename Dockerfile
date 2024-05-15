# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:56dd0b0c50f9cc8a6c9b849e085292282dda31f94a9cd57afcc887a5bdf9bd15 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:eaa989994ef8392fd199e3b7682953edff50a4b6e215ac075c9cf896ac0516a3

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
