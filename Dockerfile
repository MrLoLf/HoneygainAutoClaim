# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:041295387410c312bf49d3638cb44c8f27eb6f2d35367eee24fc8d97557649e1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:604b94c9ce7ba9af070429f423600e248a7dd0c1d65d08f0392a28a7d859e58c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
