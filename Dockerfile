# Базовый Python образ
FROM python:3.11-slim

# Устанавливаем утилиты для отладки сети и pip-зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    iputils-ping \
    curl \
    dnsutils \
    build-essential \
    && pip install --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем весь проект внутрь контейнера
COPY . /app

# Устанавливаем зависимости, если есть requirements.txt
# (Можно закомментировать, если ты хочешь это делать в Jenkins)
# RUN pip install -r requirements.txt

# Команда по умолчанию
CMD ["bash"]
