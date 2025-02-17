class Game {
  final int? id;
  final String? title;
  final String? genre;
  final String? rating;
  final String? releaseDate;
  final String? description;
  final String? imageUrl;

  Game({
    this.id,
    this.title,
    this.genre,
    this.rating,
    this.releaseDate,
    this.description,
    this.imageUrl,
  });

  // Convert JSON data into a Game object
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      genre: json['genre'],
      rating: json['rating'],
      releaseDate: json['release_date'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
}