# My Very First App!
This is my very first attempt at an app, and I don't think it's perfect. The purpose of this app is to show users video game recommendations based on their interests. I have provided a folder in this repository that shows my rough draft and my final look of the app. 

#  How It's Made
For the backend of the app, I used Python, while for the frontend, I used dart, which is provided by flutter. For the backend, I had to figure out how I was going to import all the video games (well not all) into the app, so I used and found a .csv file that contained the majority of the video games from steam and used a free API key that contained the corresponding images for the video games, although I could have extracted all the video games from the API key which might have been a better solution. For the frontend, I used the Flutter app building system, where they mainly use Dart. This part was the most challenging, considering that I had no understanding of the language, connecting the backend, or how to make the UI aesthetically pleasing. I mainly relied on YouTube and Stack Overflow, among a billion sites, to help me grasp what I needed to do. To connect the frontend and the backend, I simply created an api_service.dart file containing the ApiService class, which uses the base URL "http://127.0.0.1:5000". 

# How to Run the App
1. Git clone the project
2. Have a MacBook since this app was primarily designed to be on iOS, but it may work on Android (have not tested it).
3. Have VSCode, Xcode, and Flutter installed
4. Make sure you're in the backend directory and run app.py to run the backend.
5. Open the Runner.xcworkspace on Xcode and build the app by pressing cmd + R; the app should be built successfully.
6. The app should open on an iPhone simulator, and voila, my wonky app is now running right in front of your eyes. 

# References:
Steam data set: 

https://www.kaggle.com/datasets/wajihulhassan369/steam-games-dataset?resource=download&select=steam_cleaned.csv

Api key: rawg.io

App icon: My friend Karina Afonya designed the app icon

# Lessons Learned
Considering that this is my very first app, I would say I still have a long road ahead of me in understanding app development. Overall, I learned how to code a backend and a frontend using Python and Dart, how to connect the two, and how to utilize the api key to extract large data into the backend. 
