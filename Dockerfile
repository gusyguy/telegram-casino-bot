# Étape de compilation
FROM python:3.9-slim-bullseye as compile-image
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3-dev

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Étape finale pour l'exécution
FROM python:3.9-slim-bullseye
COPY --from=compile-image /opt/venv /opt/venv
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3-dev
RUN pip install --upgrade pip 
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app
COPY . /app

CMD ["python", "-m", "bot"]
