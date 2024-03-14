from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os


app = Flask(__name__)

if os.getenv('APP_ENV') == 'test':
    user = os.getenv('POSTGRES_USER')
    password = os.getenv('POSTGRES_PASSWORD')
    database = os.getenv('POSTGRES_DB')
    app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{user}:{password}@db:5432/{database}'

else:
    user = os.getenv('DB_USER')
    password = os.getenv('DB_PASSWORD')
    database = os.getenv('DB_NAME')
    host = os.getenv('DB_HOST')
    app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{user}:{password}@{host}:5432/{database}'

db = SQLAlchemy(app)