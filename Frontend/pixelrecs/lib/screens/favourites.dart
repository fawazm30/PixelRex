import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/api_service.dart';
import '../models/game.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavouritesScreen> {
  late Future<List<Game>> futureFavorites;

  @override
  void initState() {
    super.initState();
    futureFavorites = _fetchFavorites(); // Fetch favorite games
  }

  // Simulate fetching favorite games (replace with actual logic)
  Future<List<Game>> _fetchFavorites() async {
    // For now, fetch all games and filter favorites
    List<Game> allGames = await ApiService.fetchGames();
    return allGames.where((game) => game.rating == "Very Positive").toList(); // Example filter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: FutureBuilder<List<Game>>(
        future: futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite games found.'));
          } else {
            return ListView(
              children: snapshot.data!.map((game) {
                return GameCard(game: game); // Pass the Game object
              }).toList(),
            );
          }
        },
      ),
    );
  }
}