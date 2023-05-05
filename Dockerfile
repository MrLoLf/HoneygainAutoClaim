FROM python:3.11-slim-buster

WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/MrLoLf/HoneygainAutoClaim.git

WORKDIR /app/HoneygainAutoClaim

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]