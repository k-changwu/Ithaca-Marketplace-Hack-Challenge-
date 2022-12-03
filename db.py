from flask_sqlalchemy import SQLAlchemy
import base64
import boto3
import datetime
from io import BytesIO
from mimetypes import guess_extension, guess_type
import os
from PIL import Image
import random
import re
import string
from dotenv import load_dotenv

load_dotenv() # fix to read environment variables with os


db = SQLAlchemy()

EXTENSIONS = ["png", "gif", "jpg", "jpeg"]
BASE_DIR = os.getcwd()
S3_BUCKET_NAME_USERS = os.getenv('USERS')
S3_BUCKET_NAME_ITEMS = os.getenv("ITEMS")
S3_BASE_URL_USERS = f"https://{S3_BUCKET_NAME_USERS}.s3.us-east-1.amazonaws.com"
S3_BASE_URL_ITEMS = f"https://{S3_BUCKET_NAME_ITEMS}.s3.us-east-1.amazonaws.com"

temp = S3_BUCKET_NAME_USERS

class UserAsset(db.Model):
    """
    One to one relationship with User model.
    """
    __tablename__ = "userassets"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    base_url = db.Column(db.String, nullable = True)
    salt = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable = False)
    height = db.Column(db.Integer, nullable = False)
    created_at = db.Column(db.DateTime, nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), unique=True, nullable=True) #nullable can be false
    user = db.relationship("User", backref="userassets") 


    def __init__(self, **kwargs):
        """
        Initializes a UserAsset Object.
        """
        self.user_id = kwargs.get("user_id")
        self.create(kwargs.get("image_data"))


    def create(self, image_data):
        """
        With an image in base64 encoding, 
        - Generates a random string for the filename.
        - Decodes the image and attempts to upload it to AWS.
        - Throws an error if the file type is wrong or uploading fails.
        """
        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f"Unsupported file type: {ext}")
            
            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range(16)
            )

            img_str = re.sub("^data:image/.+;base64,","", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL_USERS
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()

            img_filename = f"{self.salt}.{self.extension}"
            self.upload(img, img_filename)

        except Exception as e:
            print(f"Error when creating image: {e}")

    def upload(self, img, img_filename):
        """
        Attempts to upload the image to the specified S3 bucket
        """
        try:
            # save temp on server
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc)

            # upload to S3
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temploc, S3_BUCKET_NAME_USERS, img_filename)

            # make S3 iage url public
            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME_USERS, img_filename)
            object_acl.put(ACL="public-read")

            # remove image from server
            os.remove(img_temploc)

        except Exception as e:
            print(f"Error when uploading image: {e}")

    def serialize(self):
        """
        Serializes a UserAsset object.
        """
        return {
            "url": f"{self.base_url}/{self.salt}.{self.extension}",
            "created_at": str(self.created_at)
        }

class ItemAsset(db.Model):
    """
    Many to one relationship with Item model.
    """
    __tablename__ = "itemassets"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    base_url = db.Column(db.String, nullable = True)
    salt = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable = False)
    height = db.Column(db.Integer, nullable = False)
    created_at = db.Column(db.DateTime, nullable = False)
    item_id = db.Column(db.Integer, db.ForeignKey("items.id"), nullable=True) #nullable can be false

    def __init__(self, **kwargs):
        """
        Initializes an ItemAsset Object.
        """
        self.item_id = kwargs.get("item_id")
        self.create(kwargs.get("image_data"))


    def create(self, image_data):
        """
        With an image in base64 encoding, 
        - Generates a random string for the filename.
        - Decodes the image and attempts to upload it to AWS.
        - Throws an error if the file type is wrong or uploading fails.
        """
        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f"Unsupported file type: {ext}")
            
            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range(16)
            )

            img_str = re.sub("^data:image/.+;base64,","", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL_ITEMS
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()

            img_filename = f"{self.salt}.{self.extension}"
            self.upload(img, img_filename)

        except Exception as e:
            print(f"Error when creating image: {e}")

    def upload(self, img, img_filename):
        """
        Attempts to upload the image to the specified S3 bucket
        """
        try:
            # save temp on server
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc)

            # upload to S3
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temploc, S3_BUCKET_NAME_ITEMS, img_filename)

            # make S3 iage url public
            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME_ITEMS, img_filename)
            object_acl.put(ACL="public-read")

            # remove image from server
            os.remove(img_temploc)

        except Exception as e:
            print(f"Error when uploading image: {e}")

    def serialize(self):
        """
        Serializes an ItemAsset object.
        """
        return {
            "url": f"{self.base_url}/{self.salt}.{self.extension}",
            "created_at": str(self.created_at)
        }

class User(db.Model):

    """
    User model.
    One to many relationship with Items model.
    One to one relationship with UserAsset model.
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    name = db.Column(db.String, nullable = False)
    description = db.Column(db.String, nullable = True) #with contact info? May have no description
    userasset = db.relationship("UserAsset", backref="users", uselist=False, cascade="delete") 
    items = db.relationship("Item", cascade="delete")
    

    #FORIEGN KEY TO IMAGE 

    #username?
    #reputation? points given by buyer if good sale. -1 if bad sale.

    def __init__(self, **kwargs):
        """
        Creates a User object
        """
        self.name = kwargs.get("name")
        self.description = kwargs.get("description", "")
    
    def serialize(self):
        """
        Serializes a User object
        """
        return {
            "id":self.id,
            "name": self.name,
            "description":self.description,
            "items": [x.serialize() for x in self.items],
            
        }

    def item_serialize(self):
        """
        Serializes a User object with only items
        """
        return {
            "items": [x.serialize() for x in self.items]
        }

class Item(db.Model):

    """
    Item model.
    Many to one relationship with Users model.
    One to many relationship with ItemAssets model.
    """
    __tablename__ = "items"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    title = db.Column(db.String, nullable = True)
    description = db.Column(db.String, nullable = True)
    price = db.Column(db.Integer, nullable = True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    images = db.relationship("ItemAsset", cascade="delete")

    def __init__(self, **kwargs):
        """
        Creates an Item object
        """
        self.title = kwargs.get("title")
        self.description = kwargs.get("description")
        self.price = kwargs.get("price")
        self.user_id = kwargs.get("user_id")

    def serialize(self):
        """
        Serializes an Item object
        """
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "price": self.price,
            "imageasset_id_list": [x.id for x in self.images]
        }


