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
  int currentPage = 1;
  int totalPages = 1;
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    futureGames = Future.value({'games': [], 'total_pages': 1}); 
  }

  void _searchGames(String query, {int page = 1}) {
    setState(() {
      currentQuery = query;
      currentPage = page;
      futureGames = ApiService.fetchGamesByTitle(query, page: page);
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
      body: Column(
        children: [
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
                    children: games.map((game) {
                      return GameCard(game: game);
                    }).toList(),
                  );
                }
              },
            ),
          ),
          //Pagination Controls
          if (totalPages > 1)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: currentPage > 1
                        ? () => _searchGames(currentQuery, page: currentPage - 1)
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Page $currentPage of $totalPages'),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages
                        ? () => _searchGames(currentQuery, page: currentPage + 1)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}