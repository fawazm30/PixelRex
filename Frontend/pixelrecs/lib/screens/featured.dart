import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/api_service.dart';
import '../models/game.dart';

class FeaturedScreen extends StatefulWidget {
  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  late Future<List<Game>> futureGames;

  @override
  void initState() {
    super.initState();
    futureGames = ApiService.fetchGames(); // Fetch games when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Game>>(
        future: futureGames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading spinner
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No games found.')); // Show empty state
          } else {
            // Display the list of games
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