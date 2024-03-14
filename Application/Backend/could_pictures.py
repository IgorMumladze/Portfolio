import cloudinary
import cloudinary.uploader
import cloudinary.api
          
cloudinary.config( 
  cloud_name = "dwer439xh", 
  api_key = "511561948123797", 
  api_secret = "4iKkGHOlhwSgd0H3LsESloEEpzQ" 
)


def upload_profile_picture(file):
    try:
        upload_result = cloudinary.uploader.upload(file)
        return upload_result['secure_url']
    except Exception as e:
        raise Exception(f"Error uploading profile picture: {str(e)}")