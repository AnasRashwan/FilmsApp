import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../models/api.dart';
import '../models/post.dart';
import '../screens/details_page.dart';
import 'fav_widget.dart';

class FilmWidget extends StatefulWidget {
  final String filmImg;
  final String filmTitle;
  final double filmRate;
  final String overview;
  final int id;
  final String origin;

  const FilmWidget(
      {required this.filmRate,
      required this.filmTitle,
      required this.filmImg,
      required this.id,
      required this.overview,
      required this.origin});

  @override
  State<FilmWidget> createState() => _FilmWidgetState();
}

class _FilmWidgetState extends State<FilmWidget> {
  String? filmImg;
  String? filmTitle;
  double? filmRate;
  String? overview;
  int? id;

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
                setState(() {});
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailsScreen(
                            filmRate: widget.filmRate,
                            filmTitle: widget.filmTitle,
                            filmImg: widget.filmImg,
                            overview: widget.overview,
                            filmId: widget.id,
                            origin: widget.origin)));
              },
              child: Container(
                width: 200,
                height: 360,
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${widget.filmImg}'),
                              fit: BoxFit.fill)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(widget.filmTitle,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          Text('Rating:  ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                          Icon(
                            size: 15,
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Text(
                            "${widget.filmRate.toString()}/10",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {});
                            },
                            child: FavoriteMovie(
                              id: widget.id,
                            ),
                          )
                        ],
                      ),
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
