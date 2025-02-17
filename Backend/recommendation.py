from models import Game

def recommend_games(user_fave_genre, db_session):
    return db_session.query(Game).filter(Game.genre == user_fave_genre).all()