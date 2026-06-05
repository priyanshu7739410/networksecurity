FROM python:3.10-slim-buster
WORKDIR /app
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["python", "app.py"]
