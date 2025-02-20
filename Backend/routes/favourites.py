from flask import Blueprint, request, jsonify
from database import db
from models import Game, User
from sqlalchemy.exc import SQLAlchemyError

favourites_bp = Blueprint('favourites', __name__)

@favourites_bp.route('/<int:user_id>/add', methods=['POST'])
def add_favourite(user_id):
    try:
        game_id = request.json.get('game_id')
        game = Game.query.get(game_id)
        if not game:
            return jsonify({'error': 'Game not found'}), 404

        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404

        # Add game to user's favourites (you need a relationship in User model for this)
        if not hasattr(user, 'favourite_games'):
            user.favourite_games = []
        user.favourite_games.append(game)
        db.session.commit()
        return jsonify({'message': 'Game added to favourites'}), 200
    except SQLAlchemyError as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@favourites_bp.route('/<int:user_id>', methods=['GET'])
def get_favourites(user_id):
    try:
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404

        favourites = user.favourite_games  # Assuming there is a relationship in the User model
        return jsonify([game.to_dict() for game in favourites]), 200
    except SQLAlchemyError as e:
        return jsonify({'error': str(e)}), 500

# Helper method to convert Game object to dictionary
def game_to_dict(game):
    return {
        'id': game.id,
        'title': game.title,
        'genre': game.genre,
        'rating': game.rating,
        'price': game.price,
        'release_date': game.release_date,
        'description': game.description,
        'image_url': game.image_url,
    }