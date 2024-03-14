from flask import Flask, jsonify, request, send_file, Response, render_template, redirect, url_for, flash, session
from flask_restful import Resource, Api
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import or_
from user_manager import register_user, login_user, logout_user, is_logged_in
from models import *
from extensions import app
import os
from funcs import *
import logging
from logging.handlers import RotatingFileHandler
from pythonjsonlogger import jsonlogger
import sys

log_handler = logging.StreamHandler(sys.stdout)
formatter = jsonlogger.JsonFormatter('%(asctime)s %(levelname)s %(message)s')
log_handler.setFormatter(formatter)
app.logger.addHandler(log_handler)
app.logger.setLevel(logging.INFO)

@app.after_request
def log_request_info(response):
    # Log the HTTP method, URL, and response status code
    app.logger.info('Request', extra={
        'request_method': request.method, 
        'request_url': request.url, 
        'response_status': response.status_code
    })
    return response

app.secret_key = 'your_secret_key'


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        firstname = request.form['firstname']
        lastname = request.form['lastname']
        email = request.form['email']
        password = request.form['password']

        if register_user(username, email, password, firstname, lastname):
            return redirect(url_for('login'))

    return render_template('register.html'), 201


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        user = User.query.filter_by(email=email).first()

        if user and login_user(email, password):
            session['logged_in'] = True
            session['username'] = user.username
            flash('Login successful.')
            return redirect(url_for('index'))
        else:
            flash('Login failed. Please check your credentials.')

    return render_template('login.html')


@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))


@app.route('/')
def index():
    if not session.get('logged_in'):
        return redirect(url_for('login')), 302
    return render_template('index.html'), 200


@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "OK"}), 200


@app.route('/recipes', methods=['GET'])
def recipes():
    # Get the search query from the form input
    search_query = request.args.get('search', '')

    is_vegan = request.args.get('is_vegan')

    # Build a query that searches in multiple fields
    query = Recipe.query.filter(
        or_(
            Recipe.dish_name.ilike(f"%{search_query}%"),
            Recipe.user_name.ilike(f"%{search_query}%"),
            Recipe.instructions.ilike(f"%{search_query}%"),
            Recipe.cuisine.ilike(f"%{search_query}%"),
            Recipe.dish_type.ilike(f"%{search_query}%"),
            Recipe.occasions.ilike(f"%{search_query}%"),
        )
    )

    if is_vegan:
        query = query.filter(Recipe.is_vegan(True))

    recipes = query.all()

    return render_template('recipes.html', recipes=recipes), 200


@app.route('/recipes/<int:recipe_id>')
def full_recipe(recipe_id):

    recipe = Recipe.query.get(recipe_id)
    if recipe is None:

        return render_template('recipe_not_found.html')

    return render_template('full_recipe.html', recipe=recipe), 200


@app.route('/recipes/delete/<int:recipe_id>', methods=['POST'])
def delete_recipe(recipe_id):
    if not session.get('logged_in'):
        flash('Please log in to delete recipes.')
        return redirect(url_for('login'))

    recipe = Recipe.query.get(recipe_id)
    if recipe.user_name != session.get('username'):
        flash('You can only delete recipes you have submitted.')
        return redirect(url_for('full_recipe', recipe_id=recipe_id))

    db.session.delete(recipe)
    db.session.commit()
    flash('Recipe deleted successfully.')
    return redirect(url_for('recipes'))


@app.route('/recipes/edit/<int:recipe_id>', methods=['GET', 'POST'])
def edit_recipe(recipe_id):
    if not session.get('logged_in'):
        flash('Please log in to edit recipes.')
        return redirect(url_for('login'))

    recipe = Recipe.query.get(recipe_id)
    if recipe.user_name != session.get('username'):
        flash('You can only edit recipes you have submitted.')
        return redirect(url_for('full_recipe', recipe_id=recipe_id))

    if request.method == 'POST':
        # Update recipe details based on form input
        recipe.dish_name = request.form.get('dish_name')
        recipe.ingredients = request.form.get('ingredients').split(',')
        recipe.cuisine = request.form.get('cuisine')
        recipe.instructions = request.form.get('instructions')
        recipe.dish_type = request.form.get('dish_type')
        recipe.cook_time = request.form.get('cook_time')
        recipe.is_vegan = request.form.get('is_vegan') == 'True'
        recipe.occasions = request.form.get('occasions').split(',')

        db.session.commit()
        flash('Recipe updated successfully.')
        return redirect(url_for('full_recipe', recipe_id=recipe_id))

    # For GET request, render the edit template with recipe details pre-filled
    return render_template('edit_recipe.html', recipe=recipe)



@app.route('/recipes/submit', methods=['GET', 'POST'])
def submit_recipe():
    if request.method == 'POST':
        try:
            # Extracting data from the form
            dish_name = request.form.get('dish_name')
            ingredients = request.form.get('ingredients')
            cuisine = request.form.get('cuisine')
            instructions = request.form.get('instructions')
            # Assuming username is stored in session
            user_name = session.get('username')
            dish_type = request.form.get('dish_type')
            cook_time = request.form.get('cook_time')
            is_vegan = request.form['is_vegan'] == 'True'  # Convert to boolean
            occasions = request.form.get('occasions')

            # Create a new Recipe instance
            new_recipe = Recipe(
                dish_name=dish_name,
                # Assuming ingredients are separated by commas
                ingredients=ingredients.split(','),
                cuisine=cuisine,
                instructions=instructions,
                user_name=user_name,  # Adjust field name as per your model
                dish_type=dish_type,
                cook_time=int(cook_time),  # Convert to int
                is_vegan=is_vegan,
                # Assuming occasions are separated by commas
                occasions=occasions.split(',')
            )

            # Add to database and commit
            db.session.add(new_recipe)
            db.session.commit()

            # Redirect or respond as necessary
            flash('Recipe submitted successfully!')
            return redirect(url_for('recipes'))

        except Exception as e:
            # Handle exceptions (e.g., missing form data, database errors)
            flash(f'Error submitting recipe: {str(e)}')
            return render_template('submit_recipe.html'), 400

    # Handle GET request
    return render_template('submit_recipe.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
