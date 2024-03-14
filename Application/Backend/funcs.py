from models import User
def get_user_profile_picture(username):
    
    user = User.query.filter_by(username=username).first()

    if user:
        return user.profile_picture
    else:
        return None 