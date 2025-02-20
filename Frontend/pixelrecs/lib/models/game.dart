class Game {
  final String? title;
  final String? imageUrl;
  final String? genre;
  final String? rating;
  final String? releaseDate;
  final String? description;

  Game({
    this.title,
    this.genre,
    this.rating,
    this.releaseDate,
    this.description,
    this.imageUrl,
  });


  // Convert a Game object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image_url': imageUrl,
      'genre': genre,
      'rating': rating,
      'releaseDate': releaseDate,
      'description': description,
    };
  }

  // Convert a JSON Map to a Game object
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'],
      imageUrl: json['image_url'],
      genre: json['genre'],
      rating: json['rating'],
      releaseDate: json['releaseDate'],
      description: json['description'],
    );
  }
}