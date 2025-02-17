import pandas as pd

df = pd.read_csv('steam_cleaned.csv')

print(df.columns)

df = df[['Name','Tags','Review_type', 'Price', 'Release_date', 'Description']]
df = df.dropna()
print(df.head())