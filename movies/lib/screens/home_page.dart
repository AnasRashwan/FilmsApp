import 'package:flutter/material.dart';
import 'package:movies/api/api.dart';
import 'package:movies/test.dart';

import '../models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          title: Center(
              child: Text("Discover",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
        ),
        body: FutureBuilder(
          future: discoverMovies,
          builder: (context, snapshot) {
            return Container(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.52),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return FilmWidget(
                        filmRate: snapshot.data![index].filmRating,
                        filmTitle: snapshot.data![index].filmName,
                        filmImg: snapshot.data![index].imageLink,
                        overview: snapshot.data![index].overview,
                    );
                  }),
            );
          },
        ));
  }
}
