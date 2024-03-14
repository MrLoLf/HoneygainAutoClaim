# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:909845588bdab160309776be62a677d1cc53211ce04dbc317cd75af974e949a0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a441185ccd7f91cdcbffe3c5285c84e3e409c786be737f8cefe813a8ef2c2ac0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
