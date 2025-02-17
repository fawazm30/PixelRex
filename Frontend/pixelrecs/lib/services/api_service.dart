import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";

  static Future<List<Game>> fetchGames({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/games?page=$page'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['games'];
      return data.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  static Future<List<Game>> fetchGamesByTitle(String title) async {
    final response = await http.get(Uri.parse('$baseUrl/games/search?query=$title'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['games'];
      return data.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games by title');
    }
  }

  static Future<List<Game>> fetchGamesByGenre(String genre) async {
    final response = await http.get(Uri.parse('$baseUrl/games/search?query=$genre'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['games'];
      return data.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games by genre');
    }
  }
}