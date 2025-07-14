FROM python:3.11-slim

WORKDIR /app
COPY . /app

# Optionally, preinstall dependencies to reduce build time
RUN pip install -r requirements.txt

CMD ["bash"]
