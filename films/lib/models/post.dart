import 'package:http/http.dart' as http;

class Movie {
  final String filmName;
  final double filmRating;
  final String imageLink;
  final String overview;
  final bool adult;
  final int id;
  final String language;

  const Movie({
    required this.filmName,
    required this.filmRating,
    required this.imageLink,
    required this.overview,
    required this.id,
    required this.adult,
    required this.language,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        filmName: json['title'],
        filmRating: json['vote_average'],
        imageLink: json['poster_path'],
        overview: json['overview'],
        id: json['id'],
        adult: json['adult'],
        language: json['original_language']);
  }
}

