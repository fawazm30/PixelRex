import pandas as pd
from sqlalchemy import create_engine, MetaData, Table, inspect, text

original_csv_file_path = '/Users/fawaz/Desktop/PixelRec/Backend/games_export.csv'
updated_csv_file_path = '/Users/fawaz/Desktop/PixelRec/Backend/games_export_with_id.csv'

df = pd.read_csv(original_csv_file_path)

df.rename(columns={
    'Name': 'title',
    'Review_type': 'rating',
    'Tags': 'genre',
    'Price': 'price',
    'Description': 'description'
}, inplace=True)

df.insert(0, 'id', range(1, 1 + len(df)))

df.to_csv(updated_csv_file_path, index=False)

print("Updated DataFrame:")
print(df.head())

engine = create_engine('sqlite:///instance/games.db')
metadata = MetaData()

with engine.connect() as connection:
    inspector = inspect(connection)
    if inspector.has_table('games'):
        print("Dropping existing 'games' table...")
        games_table = Table('games', metadata, autoload_with=engine)
        games_table.drop(engine)
        print("'games' table dropped.")

print("Creating 'games' table with updated schema...")
df.to_sql('games', con=engine, if_exists='replace', index=False)
print("Game data updated with ID column and loaded into the database!")

with engine.connect() as connection:
    result = connection.execute(text("SELECT * FROM games LIMIT 5")).fetchall()
    print("Sample data from 'games' table:")
    for row in result:
        print(row)