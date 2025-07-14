FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    iputils-ping \
    curl \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app
CMD ["bash"]

