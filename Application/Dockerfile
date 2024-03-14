FROM python:3.11

WORKDIR /app

COPY /Backend/requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY /Backend /app

EXPOSE 5000

CMD ["python3", "-u", "app.py"]
