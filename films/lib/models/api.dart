import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:films/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';
import '../widgets/film_widget.dart';

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

  Future<List<Widget>> getFavoriteMovies() async {
    await Constants().getUserUID();
    DocumentSnapshot snapshot = await Constants.favorites.get();
    List existing = snapshot["favourites"];
    for (int i = 0; i < existing.length; i++) {
      Constants.favIDs.add(existing[i]);
    }
    String filmURL;
    int filmID;
    for (int i = 0; i < Constants.favIDs.length; i++) {
      filmID = Constants.favIDs[i];
      filmURL =
          "https://api.themoviedb.org/3/movie/$filmID?api_key=${Constants.apiKey}";
      final response = await http.get(Uri.parse(filmURL));
      if (response.statusCode == 200) {
        FilmWidget film = FilmWidget(
          filmRate: jsonDecode(response.body)["vote_average"],
          filmTitle: jsonDecode(response.body)["title"],
          filmImg: jsonDecode(response.body)["poster_path"],
          id: jsonDecode(response.body)["id"],
          overview: jsonDecode(response.body)["overview"],
          origin: "favorite",
        );
        Constants.favMovies.add(film);
      } else {
        throw Exception('Something Went Wrong');
      }
    }
    return Constants.favMovies;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String?> getUserUID() async {
    // Get the current user
    User? user = _auth.currentUser;
    // Check if the user is authenticated
    if (user != null) {
      // Return the UID of the authenticated user
      return user.uid;
    } else {
      // User is not signed in
      return null;
    }
  }
}


