import 'package:flutter/material.dart';
import '../widgets/gamecard.dart';
import '../services/favourite_service.dart';
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
    loadFavorites();
  }

  void loadFavorites() {
    futureFavorites = FavoritesService.getFavorites();
  }

  Future<void> removeGame(Game game) async {
    await FavoritesService.removeFavorite(game);
    setState(() {
      loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear All Favorites'),
                  content: Text('Are you sure you want to remove all favorites?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('Clear All'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await FavoritesService.clearFavorites();
                setState(() {
                  loadFavorites();
                });
              }
            },
          ),
        ],
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final game = snapshot.data![index];
                return Dismissible(
                  key: Key(game.title ?? 'game-${game.hashCode}'),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    removeGame(game);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${game.title ?? 'Game'} removed from favorites'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            await FavoritesService.addFavorite(game);
                            setState(() {
                              loadFavorites();
                            });
                          },
                        ),
                      ),
                    );
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Remove from Favorites'),
                        content: Text('Are you sure you want to remove ${game.title ?? 'this game'} from favorites?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: Text('Remove'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: GameCard(game: game),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}