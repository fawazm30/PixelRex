import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart';

class FavoritesService {
  static const String favoritesKey = 'favorite_games';

  static Future<void> addFavorite(Game game) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    // Ensure no duplicates if needed
    favorites.add(game);
    final jsonFavorites = favorites.map((g) => json.encode(g.toJson())).toList();
    await prefs.setStringList(favoritesKey, jsonFavorites);
  }

  static Future<List<Game>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonFavorites = prefs.getStringList(favoritesKey) ?? [];
    return jsonFavorites.map((jsonStr) => Game.fromJson(json.decode(jsonStr))).toList();
  }
}
