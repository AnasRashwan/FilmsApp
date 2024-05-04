import 'dart:async';
import 'dart:convert';

import 'package:movies/constants.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class Api {
  static const _discoverURL =
      'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}';
   static int itemsCount = 0;

  Future<List<Movie>> getDiscoverMovies() async {
    final response = await http.get(Uri.parse(_discoverURL));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)["results"] as List;
      itemsCount = decodedData.length;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something Went Wrong');
    }
  }
}
