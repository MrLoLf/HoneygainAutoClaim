# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:312dcadccf5bfa7a69dd11bbdb0838a49a9993d72225b69a2de1928d5c5f9735 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c949df891e5463d357b4d8779aa5bf052e8f53cfe7479c95b2ca4ea3b6156634

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
