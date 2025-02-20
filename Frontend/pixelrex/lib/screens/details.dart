import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/favourite_service.dart';

class GameDetailsScreen extends StatelessWidget {
  final Game game;

  GameDetailsScreen({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title ?? 'Game Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              game.imageUrl ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              game.title ?? 'Unknown Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("Genre: ${game.genre ?? 'Unknown Genre'}"),
            SizedBox(height: 8),
            Text("Rating: ${game.rating ?? 'Unknown Rating'}"),
            SizedBox(height: 8),
            Text("Release Date: ${game.releaseDate ?? 'Unknown Date'}"),
            SizedBox(height: 16),
            Text(
              game.description ?? 'No description available.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await FavoritesService.addFavorite(game);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Added to favorites"))
                );
              },
              child: Text("Add to Favorites"),
            ),
          ],
        ),
      ),
    );
  }
}