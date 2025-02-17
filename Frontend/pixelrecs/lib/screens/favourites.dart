import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/favourite_service.dart'; // Updated import for our new service
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
    // Fetch favorite games from persistent storage
    futureFavorites = FavoritesService.getFavorites();
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
              children: snapshot.data!.map((game) => GameCard(game: game)).toList(),
            );
          }
        },
      ),
    );
  }
}
