import requests
import pandas as pd
from sqlalchemy import create_engine
import time
import random

df = pd.read_csv("steam_cleaned.csv")
API_key = "4145f023035e40969016c0f2999dc338"

def game_image (game_name):
    url = f"https://api.rawg.io/api/games?key={API_key}&search={game_name}"
    
    try:
        response = requests.get(url)
        response.raise_for_status()

        data = response.json()
        if 'results' in data and len(data['results']) > 0:
            return data['results'][0]['background_image']
        else:
            return None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {game_name}: {e}")
        return None
    finally:
        time.sleep(random.uniform(1, 2))

df ["image_url"] = df["Name"].apply(game_image)
df.to_csv("steam_with_images.csv", index=False)

engine = create_engine('sqlite:///instance/games.db')
df.to_sql('games', con=engine, if_exists='replace', index=False)

print("DGame data updated with image URLs!")