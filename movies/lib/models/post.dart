import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;


class Movie {
  final String filmName;
  final double filmRating;
  final String imageLink;
  final String overview;

  const Movie({
    required this.filmName,
    required this.filmRating,
    required this.imageLink,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        filmName: json['title'],
        filmRating: json['popularity'],
        imageLink: json['backdrop_path'],
        overview: json['overview']
    );
  }
}

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://api.themoviedb.org/3/discover/movie?api_key=0ffd462cdd720db4188f270fc3be6a3d'));
}




