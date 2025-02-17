import csv
from app import app, db
from models import Game

def import_games(csv_file):
    with app.app_context():
        with open(csv_file, newline='', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)

            for row in reader:
                game = Game(title=row['Name'], genre=row['Tags'], rating=row['Review_type'], price=row['Price'], release_date=row['Release_date'], description=row['Description'])
                db.session.add(game)
            db.session.commit()
            print('Data imported successfully!')
if __name__ == '__main__':
    import_games('steam_cleaned.csv')

