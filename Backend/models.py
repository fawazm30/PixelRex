from database import db

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    favorite_genre = db.Column(db.String(255), nullable=False)
    favourite_games = db.relationship('Game', secondary='user_favourites', backref='favourited_by')  

class Game(db.Model):
    __tablename__ = 'games'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    genre = db.Column(db.String(255), nullable=False)
    rating = db.Column(db.String(50), nullable=False)
    price = db.Column(db.Integer)
    release_date = db.Column(db.String(50))
    description = db.Column(db.Text)
    image_url = db.Column(db.String(255))

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'genre': self.genre,
            'rating': self.rating,
            'price': self.price,
            'release_date': self.release_date,
            'description': self.description,
            'image_url': self.image_url,
        }

user_favourites = db.Table('user_favourites',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id')),
    db.Column('game_id', db.Integer, db.ForeignKey('games.id'))
)