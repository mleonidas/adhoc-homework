FROM python:3.9.0a4-alpine3.10
WORKDIR /app

COPY src/ .
# Install dependencies 
RUN pip install --no-cache-dir -r requirements.txt \
  && rm requirements.txt

EXPOSE 8000/tcp

CMD [ "gunicorn", "--workers=2", "--bind=0.0.0.0:8000", "server:app" ]
