FROM python:3.11-slim
COPY . /python_test
WORKDIR /python_test
RUN pip install --no-cache-dir -r requirements.txt
RUN ["pytest", "-v", "--junitxml=reports/result.xml"]
CMD tail -f /dev/null
