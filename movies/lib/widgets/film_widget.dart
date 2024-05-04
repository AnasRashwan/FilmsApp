import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/screens/details_screen.dart';

import '../api/api.dart';
import '../models/post.dart';

class FilmWidget extends StatefulWidget {
  final String filmImg;
  final String filmTitle;
  final double filmRate;
  final String overview;

  const FilmWidget(
      {required this.filmRate,
      required this.filmTitle,
      required this.filmImg,
      required this.overview});

  @override
  State<FilmWidget> createState() => _FilmWidgetState();
}

class _FilmWidgetState extends State<FilmWidget> {
  late Future<List<Movie>> discoverMovies;

  @override
  void initState() {
    super.initState();
    discoverMovies = Api().getDiscoverMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailsScreen(
                            filmRate: widget.filmRate,
                            filmTitle: widget.filmTitle,
                            filmImg: widget.filmImg,
                            overview: widget.overview)));
              },
              child: Container(
                width: 180,
                height: 355,
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: discoverMovies,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else if (snapshot.hasData) {
                            print("${snapshot.data}");
                            return Container(
                              height: 220,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://image.tmdb.org/t/p/w500${widget.filmImg}'),
                                      fit: BoxFit.fill)),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(widget.filmTitle,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(widget.filmRate.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
