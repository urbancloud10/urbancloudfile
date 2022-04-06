from flask import Flask

app = Flask(__name__)

@app.route("/tree")
def tree():
    return {"myFavouriteTree": "evergreen oak"}