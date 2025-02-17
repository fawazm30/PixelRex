from database import db

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    favorite_genre = db.Column(db.String(255), nullable=False)

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

    def __rep__(self):
        return f"{self.title}"