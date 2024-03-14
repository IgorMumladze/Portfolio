from flask import request, flash, redirect, url_for, session
from werkzeug.security import generate_password_hash, check_password_hash
from models import User  # Import your User model
from extensions import db

def register_user(username, email, password, firstname, lastname):

    existing_user = User.query.filter((User.username == username) | (User.email == email)).first()

    if existing_user:
        flash('Username or email is already taken.')
        return False


    hashed_password = generate_password_hash(password, method='sha256')

  
    new_user = User(username=username, email=email, password=hashed_password, firstname=firstname, lastname=lastname)
    db.session.add(new_user)
    db.session.commit()
    return True

def login_user(email, password):
    user = User.query.filter_by(email=email).first()

    if user and check_password_hash(user.password, password):
      
        session['user_id'] = user.id 
        return True
    else:
        return False

def logout_user():
    session.pop('user_id', None)  

def is_logged_in():
    return 'user_id' in session
