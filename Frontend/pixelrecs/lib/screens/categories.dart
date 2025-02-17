import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/api_service.dart';
import '../models/game.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Game>> futureGames;
  String selectedGenre = "Action"; // Default selected genre

  @override
  void initState() {
    super.initState();
    futureGames = ApiService.fetchGamesByGenre(selectedGenre); // Fetch games by genre
  }

  void _onGenreSelected(String genre) {
    setState(() {
      selectedGenre = genre;
      futureGames = ApiService.fetchGamesByGenre(genre); // Fetch games for the new genre
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: Column(
        children: [
          // Genre selection buttons
          Container(
            height: 60, // Set a fixed height for the genre buttons
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGenreButton("Action"),
                  _buildGenreButton("Adventure"),
                  _buildGenreButton("Battle Royale"),
                  _buildGenreButton("Casual"),
                  _buildGenreButton("Fantasy"),
                  _buildGenreButton("Free to Play"),
                  _buildGenreButton("JRPG"),
                  _buildGenreButton("Multiplayer"),
                  _buildGenreButton("Open World"),
                  _buildGenreButton("MMORPG"),
                  _buildGenreButton("RPG"),
                  _buildGenreButton("Shooter"),
                  _buildGenreButton("Survival"),
                  _buildGenreButton("Horror"),
                ],
              ),
            ),
          ),
          // List of games
          Expanded(
            child: FutureBuilder<List<Game>>(
              future: futureGames,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No games found.'));
                } else {
                  return ListView(
                    children: snapshot.data!.map((game) {
                      return GameCard(game: game); // Pass the Game object
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build genre buttons
  Widget _buildGenreButton(String genre) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () => _onGenreSelected(genre),
        child: Text(genre),
      ),
    );
  }
}