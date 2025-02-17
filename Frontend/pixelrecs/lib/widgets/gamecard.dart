import 'package:flutter/material.dart';
import '../models/game.dart'; // Import the Game model

class GameCard extends StatelessWidget {
  final Game game; // Accept a Game object

  GameCard({required this.game}); // Require the Game object

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            game.imageUrl ?? 'https://via.placeholder.com/150', // Fallback image
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title ?? 'Unknown Title', // Fallback title
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(game.genre ?? 'Unknown Genre'), // Fallback genre
                SizedBox(height: 4),
                Text("Rating: ${game.rating ?? 'Unknown Rating'}"), // Fallback rating
                SizedBox(height: 4),
                Text("Release Date: ${game.releaseDate ?? 'Unknown Date'}"), // Fallback release date
              ],
            ),
          ),
        ],
      ),
    );
  }
}