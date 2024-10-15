import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:films/models/api.dart';
import 'package:flutter/material.dart';
import 'package:films/Constants.dart';
import 'film_widget.dart';

class FavoriteMovie extends StatefulWidget {
  final int id;

  const FavoriteMovie({
    required this.id,
  });

  @override
  State<FavoriteMovie> createState() => _FavoriteMovieState();
}

class _FavoriteMovieState extends State<FavoriteMovie> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          bool isFav = Constants.favIDs.contains(widget.id);
          if (isFav) {
            Constants.favIDs.remove(widget.id);
            setState(() {});
          } else {
            Constants.favIDs.add(widget.id);
            setState(() {});
          }
          Constants.favorites.set({"favourites": Constants.favIDs});
          setState(() {});
        },
        icon: Constants.favIDs.contains(widget.id)
            ? Icon(Icons.favorite, color: Colors.red)
            : Icon(Icons.favorite_border));
  }
}
