# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9ee3605335cc8f68d8fb18ecf198aa984428015b65d84c0983d045920fd59ae7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:227fc741b1ff222576390c28900831e34f817016aa76292913e50f778083f988

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
