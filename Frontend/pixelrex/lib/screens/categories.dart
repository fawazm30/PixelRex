import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/gamecard.dart';
import '../models/game.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<Map<String, dynamic>> futureGames;
  String selectedGenre = "Action"; // Default selected genre
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  void fetchGames() {
    futureGames = ApiService.fetchGamesByGenre(selectedGenre, page: currentPage);
    futureGames.then((result) {
      setState(() {
        totalPages = result['total_pages'];
      });
    });
  }

  void _onGenreSelected(String genre) {
    setState(() {
      selectedGenre = genre;
      currentPage = 1; // Reset to first page
      fetchGames();
    });
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: currentPage > 1 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey.withOpacity(0.5),
            ),
            onPressed: currentPage > 1
                ? () {
                    setState(() {
                      currentPage--;
                      fetchGames();
                    });
                  }
                : null,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 203, 47, 36),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'Page $currentPage of $totalPages',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: currentPage < totalPages 
                  ? const Color.fromARGB(255, 203, 47, 36)
                  : Colors.grey.withOpacity(0.5),
            ),
            onPressed: currentPage < totalPages
                ? () {
                    setState(() {
                      currentPage++;
                      fetchGames();
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                "Action", "Adventure", "RPG", "Strategy", "Sports", "Racing"
              ].map((genre) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () => _onGenreSelected(genre),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGenre == genre  // Changed from primary to backgroundColor
                        ? const Color.fromARGB(255, 203, 47, 36) 
                        : Colors.grey.shade200,
                  ),
                  child: Text(
                    genre,
                    style: TextStyle(
                      color: selectedGenre == genre ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
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
                    children: games.map((game) => GameCard(game: game)).toList(),
                  );
                }
              },
            ),
          ),
          if (totalPages > 1) _buildPaginationControls(),
        ],
      ),
    );
  }
}