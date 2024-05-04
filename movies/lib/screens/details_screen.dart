import 'package:flutter/material.dart';
import 'package:movies/screens/home_page.dart';

import '../api/api.dart';
import '../models/post.dart';

class DetailsScreen extends StatefulWidget {
  final String filmImg;
  final String filmTitle;
  final double filmRate;
  final String overview;

  const DetailsScreen(
      {required this.filmRate,
      required this.filmTitle,
      required this.filmImg,
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
              Navigator.pop(
                  context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                  width: 370,
                  height: 330,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500${widget.filmImg}')),
                  )),
              SizedBox(height: 15),
              Text(widget.filmTitle,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900)),
              SizedBox(height: 10),
              Text(widget.overview,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w900)),
              SizedBox(height: 10),
              Text(widget.filmRate.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ));
  }
}
