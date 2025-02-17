import pandas as pd
from sqlalchemy import create_engine, MetaData, Table, inspect, text

# Define the path to the original and updated CSV files
original_csv_file_path = '/Users/fawaz/Desktop/PixelRec/Backend/games_export.csv'
updated_csv_file_path = '/Users/fawaz/Desktop/PixelRec/Backend/games_export_with_id.csv'

# Read the original CSV file into a DataFrame
df = pd.read_csv(original_csv_file_path)

# Rename the columns
df.rename(columns={
    'Name': 'title',
    'Review_type': 'rating',
    'Tags': 'genre',
    'Price': 'price',
    'Description': 'description'
}, inplace=True)

# Add an 'id' column with unique values
df.insert(0, 'id', range(1, 1 + len(df)))

# Save the updated DataFrame back to a new CSV file
df.to_csv(updated_csv_file_path, index=False)

# Print the DataFrame to verify the changes
print("Updated DataFrame:")
print(df.head())

# Create a connection to the SQLite database
engine = create_engine('sqlite:///instance/games.db')
metadata = MetaData()

# Drop the existing 'games' table if it exists
with engine.connect() as connection:
    inspector = inspect(connection)
    if inspector.has_table('games'):
        print("Dropping existing 'games' table...")
        games_table = Table('games', metadata, autoload_with=engine)
        games_table.drop(engine)
        print("'games' table dropped.")

# Define the 'games' table with the correct schema and load the data
print("Creating 'games' table with updated schema...")
df.to_sql('games', con=engine, if_exists='replace', index=False)
print("Game data updated with ID column and loaded into the database!")

# Verify the contents of the 'games' table
with engine.connect() as connection:
    result = connection.execute(text("SELECT * FROM games LIMIT 5")).fetchall()
    print("Sample data from 'games' table:")
    for row in result:
        print(row)