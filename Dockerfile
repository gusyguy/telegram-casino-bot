# Отдельный сборочный образ
FROM python:3.9-slim-bullseye as compile-image
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip setuptools wheel

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel

RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Итоговый образ, в котором будет работать бот
FROM python:3.9-slim-bullseye
COPY --from=compile-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app
COPY bot /app/bot
CMD ["python", "-m", "bot"]
