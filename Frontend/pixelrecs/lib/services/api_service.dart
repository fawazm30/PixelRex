import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000"; //connects the backend to the frontend

  static Future<Map<String, dynamic>> fetchGames({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/games?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<Game> games = (data['games'] as List).map((game) => Game.fromJson(game)).toList();
      return {
        'games': games,
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to load games');
    }
  }

  static Future<Map<String, dynamic>> fetchGamesByTitle(String title, {int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/games/search?query=$title&page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<Game> games = (data['games'] as List).map((game) => Game.fromJson(game)).toList();
      return {
        'games': games,
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to load games by title');
    }
  }

  static Future<Map<String, dynamic>> fetchGamesByGenre(String genre, {int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/games/search?query=$genre&page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<Game> games = (data['games'] as List).map((game) => Game.fromJson(game)).toList();
      return {
        'games': games,
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to load games by genre');
    }
  }
}