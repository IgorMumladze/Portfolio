from extensions import *  # Import the db object from extensions.py



class Recipe(db.Model):
    __tablename__ = 'recipes'
    id = db.Column(db.Integer, primary_key=True)
    dish_name = db.Column(db.String(255), nullable=False)
    ingredients = db.Column(db.ARRAY(db.Text))
    cuisine = db.Column(db.String(100))
    instructions = db.Column(db.Text)
    date_time = db.Column(db.TIMESTAMP)
    user_name = db.Column(db.String(100))
    dish_type = db.Column(db.String(100))
    cook_time = db.Column(db.Integer)
    occasions = db.Column(db.String(100))
    is_vegan = db.Column(db.Boolean)

class User(db.Model):
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    firstname = db.Column(db.String(100), nullable=True)
    lastname = db.Column(db.String(100), nullable=True) 

    def __init__(self, username, email, password, firstname, lastname):
        self.username = username
        self.email = email
        self.password = password
        self.firstname = firstname  # Set the firstname value
        self.lastname = lastname    # Set the lastname value