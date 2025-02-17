import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/api_service.dart';
import '../models/game.dart';

class FeaturedScreen extends StatefulWidget {
  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  late Future<Map<String, dynamic>> actionGames;
  late Future<Map<String, dynamic>> multiplayerGames;
  late Future<Map<String, dynamic>> freeToPlayGames;
  late Future<Map<String, dynamic>> horrorGames;

  @override
  void initState() {
    super.initState();
    actionGames = ApiService.fetchGamesByGenre('Action');
    multiplayerGames = ApiService.fetchGamesByGenre('Multiplayer');
    freeToPlayGames = ApiService.fetchGamesByGenre('Free to Play');
    horrorGames = ApiService.fetchGamesByGenre('Horror');
  }

  Widget buildCategory(String title, Future<Map<String, dynamic>> futureGames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<Map<String, dynamic>>(
          future: futureGames,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!['games'].isEmpty) {
              return Center(child: Text('No games found.'));
            } else {
              List<Game> games = snapshot.data!['games'];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: games.map((game) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GameCard(game: game),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Featured Games'),
      ),
      body: ListView(
        children: [
          buildCategory('Action', actionGames),
          buildCategory('Multiplayer', multiplayerGames),
          buildCategory('Free to Play', freeToPlayGames),
          buildCategory('Horror', horrorGames),
        ],
      ),
    );
  }
}