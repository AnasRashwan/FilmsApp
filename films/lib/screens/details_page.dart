import 'package:films/screens/favorite_movies.dart';
import 'package:flutter/material.dart';
import '../models/api.dart';
import '../models/post.dart';
import '../widgets/fav_widget.dart';
import 'home_page.dart';

class DetailsScreen extends StatefulWidget {
  final String filmImg;
  final String filmTitle;
  final double filmRate;
  final String overview;
  final int filmId;
  final String origin;

  const DetailsScreen(
      {required this.filmRate,
      required this.filmTitle,
      required this.filmImg,
      required this.filmId,
      required this.origin,
      required this.overview});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<List<Movie>> discoverMovies;

  @override
  void initState() {
    super.initState();
    discoverMovies = Api().getDiscoverMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (widget.origin == 'home') {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePage(key: UniqueKey())));
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => FavoriteScreen(key: UniqueKey())));
              }
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500${widget.filmImg}')),
                  )),
              SizedBox(height: 15),
              Text(widget.filmTitle,
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w900)),
              SizedBox(height: 10),
              Text(widget.overview,
                  style: TextStyle(
                      fontSize: widget.overview.length >= 100 ? 20 : 23,
                      color: Colors.white70,
                      fontWeight: FontWeight.w900)),
              SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text('Rating:  ',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700)),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        "${widget.filmRate.toString()}/10",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      FavoriteMovie(
                        id: widget.filmId,
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
