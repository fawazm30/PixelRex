import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/api_service.dart';
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

  void _onPageSelected(int page) {
    setState(() {
      currentPage = page;
      fetchGames();
    });
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];
    int maxPagesToShow = 5;

    if (totalPages <= maxPagesToShow) {
      for (int i = 1; i <= totalPages; i++) {
        pageNumbers.add(_buildPageNumberButton(i));
      }
    } else {
      if (currentPage > 3) {
        pageNumbers.add(_buildPageNumberButton(1));
        pageNumbers.add(_buildEllipsis());
      }

      int startPage = currentPage > 3 ? currentPage - 2 : 1;
      int endPage = currentPage + 2 < totalPages ? currentPage + 2 : totalPages;

      for (int i = startPage; i <= endPage; i++) {
        pageNumbers.add(_buildPageNumberButton(i));
      }

      if (currentPage + 2 < totalPages) {
        pageNumbers.add(_buildEllipsis());
        pageNumbers.add(_buildPageNumberButton(totalPages));
      }
    }

    return pageNumbers;
  }

  Widget _buildPageNumberButton(int page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: TextButton(
        onPressed: () => _onPageSelected(page),
        style: TextButton.styleFrom(
          backgroundColor: currentPage == page ? Colors.blue : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: currentPage == page ? Colors.white : Colors.blue,
            fontWeight: currentPage == page ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text('...'),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: TextButton(
        onPressed: () => _onPageSelected(currentPage + 1),
        child: Icon(Icons.arrow_forward, color: Colors.blue),
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
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
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: games.map((game) {
                            return GameCard(game: game); // Pass the Game object
                          }).toList(),
                        ),
                      ),
                      // Pagination buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ..._buildPageNumbers(),
                            _buildNextButton(),
                          ],
                        ),
                      ),
                    ],
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