from flask import Blueprint, request, jsonify
from database import db
from models import Game

games_bp = Blueprint('games', __name__)

def build_game_query(filters):
    query = Game.query
    if 'genre' in filters and filters ['genre']:
        query = query.filter(Game.genre.ilike(f"%{filters['genre']}%"))
    if 'title' in filters and filters ['title']:
        query = query.filter(Game.title.ilike(f"%{filters['title']}%"))
    if 'price' in filters and filters ['price']:
        query = query.filter(Game.price == filters['price'])
    if 'rating' in filters and filters ['rating']:
        query = query.filter(Game.rating.ilike(f"%{filters['rating']}%"))
    return query

@games_bp.route('/', methods=['GET'])
def get_games():
    try:
        page = request.args.get('page', 1, type=int)
        limit = request.args.get('limit', 10, type=int)
        filters = {
            'genre': request.args.get('genre', type=str),
            'title': request.args.get('title', type=str),
            'price': request.args.get('price', type=int),
            'rating': request.args.get('rating', type=str)
        }

        query = build_game_query(filters)
        games_query = query.paginate(page=page, per_page=limit, error_out=False)
        games = [{
            "id": game.id,
            "title": game.title,
            "genre": game.genre,
            "rating": game.rating,
            "price": game.price,
            "release_date": game.release_date,
            "description": game.description,
            "image_url": game.image_url
        } for game in games_query.items]
        return jsonify({
            "games": games,
            "page": page,
            "total_pages": games_query.pages,
            "total_games": games_query.total
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@games_bp.route('/search', methods=['GET'])
def search_games():
    try:
        query = request.args.get('query', type=str)
        page = request.args.get('page', 1, type=int)
        limit = request.args.get('limit', 10, type=int)

        if not query:
            return jsonify({"error": "Search query is required"}), 400
        game_query = Game.query.filter(
            Game.title.ilike(f"%{query}%") | Game.genre.ilike(f"%{query}%")
        ).paginate(page=page, per_page=limit, error_out=False)

        games = [{
            "id": game.id,
            "title": game.title,
            "genre": game.genre,
            "rating": game.rating,
            "price": game.price,
            "release_date": game.release_date,
            "description": game.description,
            "image_url": game.image_url
        } for game in game_query.items]

        return jsonify({
            "games": games,
            "page": page,
            "total_pages": game_query.pages,
            "total_games": game_query.total
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500