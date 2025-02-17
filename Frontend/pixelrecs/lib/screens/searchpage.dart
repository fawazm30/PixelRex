import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/api_service.dart';
import '../models/game.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<Map<String, dynamic>> futureGames;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    futureGames = Future.value({'games': [], 'total_pages': 1}); // Initialize with an empty list
  }

  void _searchGames(String query) {
    setState(() {
      futureGames = ApiService.fetchGamesByTitle(query, page: 1);
      futureGames.then((result) {
        setState(() {
          totalPages = result['total_pages'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search games...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchGames(_searchController.text);
              },
            ),
          ),
          onSubmitted: (query) {
            _searchGames(query);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
            return ListView(
              children: games.map((game) {
                return GameCard(game: game); // Pass the Game object
              }).toList(),
            );
          }
        },
      ),
    );
  }
}