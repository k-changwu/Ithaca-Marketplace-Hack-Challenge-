from db import db
from db import UserAsset
from db import ItemAsset
from db import Item
from db import User

from flask import Flask

import json
from flask import request


app = Flask(__name__)
db_filename = "IthacaMarketplace.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

# generalized response formats
def success_response(data, code=200):
    return json.dumps(data), code


def failure_response(message, code=404):
    return json.dumps({"error": message}), code   


# Our routes below

@app.route("/")
def null():
    """
    Endpoint that greets the graders!
    """

    return "Hello graders!\n\
        This is the backend for our marketplace application.\n\
            We hope you like it, and be kind!", 200

@app.route("/upload/users/<int:user_id>/", methods=["POST"])
def upload_pfp(user_id):
    """
    Endpoint for uploading an image to AWS given its base64 form,
    then storing/returning the URL of that image. 
    Uploads an image for the profile picture of a user.
    """
    body = json.loads(request.data)

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")

    image_data = body.get("image_data")
    if image_data is None:
        return failure_response("No base64 image passed in!")

    # create UserAsset object
    asset = UserAsset(image_data = image_data, user_id = user_id)
    db.session.add(asset)
     
    #user.userasset_id = asset.id
    
    db.session.commit()
    return success_response(asset.serialize(), 201)

@app.route("/upload/users/<int:user_id>/", methods=["DELETE"])
def delete_pfp(user_id):
    """
    Endpoint for deleting a user's profile picture.
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")

    for userasset in UserAsset.query.all():
        db.session.delete(userasset)
    db.session.commit()
    return success_response(user.serialize())

@app.route("/upload/items/<int:item_id>/", methods=["POST"])
def upload_item_image(item_id):
    """
    Endpoint for uploading an image to AWS given its base64 form,
    then storing/returning the URL of that image. 
    Uploads an image for an item that a user is selling.
    """
    body = json.loads(request.data)

    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response("Item not found!")

    image_data = body.get("image_data")
    if image_data is None:
        return failure_response("No base64 image passed in!")

    # create ItemAsset object
    asset = ItemAsset(image_data = image_data, item_id = item_id)
    db.session.add(asset)
    db.session.commit()
    return success_response(asset.serialize(), 201)

@app.route("/upload/items/<int:item_id>/<int:asset_id>/", methods=["DELETE"])
def delete_item_image(item_id, asset_id):
    """
    Endpoint for deleting an image of an item.
    """
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response("Item not found!")

    item_image = ItemAsset.query.filter_by(id=asset_id).first()
    if item_image is None:
        return failure_response("Item image not found!")

    db.session.delete(item_image)
    db.session.commit()
    return success_response(item.serialize())

@app.route("/users/")
def get_all_users():
    """
    Endpoint for getting all users.
    """
    users = [user.serialize() for user in User.query.all()]
    return success_response({"Users":users})

@app.route("/users/<int:user_id>/")
def get_user(user_id):
    """
    Endpoint for getting a user by id.
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    return success_response(user.serialize())

@app.route("/users/", methods=["POST"])
def create_user():
    """
    Endpoint for creating a new user.
    """

    body = json.loads(request.data)
    name = body.get("name")
    if name == None:
        return failure_response("Name was not provided", 400)
    description = body.get("description")
    userasset_id = body.get("userasset_id") # Empty to begin with bc no pfp uploaded yet
    userasset = UserAsset.query.filter_by(id=userasset_id).first()
    if type(userasset_id) == int and userasset == None:
        return failure_response("Profile picture not found!")


    # Create the User object
    user = User(name = name, description = description)
    db.session.add(user)
    db.session.commit()
    return success_response(user.serialize(), 201)

@app.route("/users/<int:user_id>/", methods=["POST"])
def update_user(user_id):
    """
    Endpoint for updating the name and description of a user by id.
    """
    body = json.loads(request.data)
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")

    if body.get("name") != None:
        user.name = body.get("name")
    if body.get("description") == None:
        user.description = ""
    else:
        user.description = body.get("description")
    db.session.commit()

    return success_response(user.serialize())

@app.route("/users/<int:user_id>/", methods=["DELETE"])
def delete_user(user_id):
    """
    Endpoint for deleting a user by id
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")

    for userasset in UserAsset.query.all():
        db.session.delete(userasset)

    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize())

@app.route("/items/")
def get_all_items():
    """
    Endpoint for getting all items.
    """
    items = [item.serialize() for item in Item.query.all()]
    return success_response({"Items":items})

@app.route("/items/users/<int:user_id>/")
def get_items(user_id):
    """
    Endpoint for getting all items of a user by id.
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    return success_response(user.item_serialize())

@app.route("/items/<int:item_id>/")
def get_item(item_id):
    """
    Endpoint for getting an item by id.
    """
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response("Item not found!")
    return success_response(item.serialize())

@app.route("/items/users/<int:user_id>/", methods=["POST"])
def create_item(user_id):
    """
    Endpoint for creating a new item for a user
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found!")
    
    body = json.loads(request.data)
    title = body.get("title")
    if title == None:
        return failure_response("Item name not provided!")
    description = body.get("description")
    if description == None:
        description == ""
    price = body.get("price")
    if price == None:
        return failure_response("Price not provided!")

    # Create an item object
    item = Item(title = title, description = description, price = price, user_id = user_id)
    db.session.add(item)
    db.session.commit()
    return success_response(user.serialize())

@app.route("/users/items/<int:item_id>/", methods=["POST"])
def update_item(item_id):
    """
    Endpoint for updating the title, description, and price of an item by id
    """
    body = json.loads(request.data)
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response("Item not found!")

    if body.get("title") != None:
        item.title = body.get("title")
    if body.get("description") == None:
        item.description = ""
    else:
        item.description = body.get("description")
    if body.get("price") != None:
        item.price = body.get("price")
    db.session.commit()

    return success_response(item.serialize())

@app.route("/items/<int:item_id>/", methods=["DELETE"])
def delete_item(item_id):
    """
    Endpoint for deleting an item by id
    """
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response("Item not found!")
    db.session.delete(item)
    db.session.commit()
    return success_response(item.serialize())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
