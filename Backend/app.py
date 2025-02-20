from flask import Flask, jsonify
from flask_cors import CORS
from database import db
from routes.users import users_bp
from routes.games import games_bp
from routes.favourites import favourites_bp  # Import the new route

app = Flask(__name__)
CORS(app)

app.config.from_object('config.Config')
db.init_app(app)

app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(games_bp, url_prefix='/games')
app.register_blueprint(favourites_bp, url_prefix='/favourites')  # Register the new route

@app.route('/')
def home():
    return {"message": "Welcome to the Video Game Recommendation PixelRecs"}

if __name__ == '__main__':
    app.run(debug=True)