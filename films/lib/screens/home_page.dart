import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Constants.dart';
import '../models/api.dart';
import '../models/post.dart';
import '../widgets/film_widget.dart';
import 'favorite_movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> discoverMovies;
  late Future<List<Widget>> favoriteMovies;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Future<List<Movie>> _moviesFuture;

  Future<void> signOut() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      googleSignIn.signOut();
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'Login');
    } else {
      print("No user to sign out");
    }
  }

  @override
  void initState() {
    Constants.favIDs.clear();
    Constants.favMovies.clear();
    discoverMovies = Api().getDiscoverMovies();
    favoriteMovies = Api().getFavoriteMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([discoverMovies, favoriteMovies]),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
                appBar: AppBar(
                  leading: SizedBox(),
                  actions: [
                    Text("Discover",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () {
                        List<FilmWidget> movieWidgets =
                            snapshot.data![0].map<FilmWidget>((movie) {
                          return FilmWidget(
                            filmRate: movie.filmRating,
                            filmTitle: movie.filmName,
                            filmImg: movie.imageLink,
                            overview: movie.overview,
                            id: movie.id,
                            origin: "search",
                          );
                        }).toList();
                        showSearch(
                            context: context,
                            delegate:
                                CustomSearchDelegate(allMovies: movieWidgets));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FavoriteScreen()));
                          setState(() {});
                        },
                        icon: Icon(Icons.favorite_border)),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "Profile");
                        },
                        icon: Icon(Icons.person)),
                    IconButton(
                        onPressed: () async {
                          await signOut();
                        },
                        icon: Icon(Icons.logout))
                  ],
                ),
                body: Container(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.54),
                      itemCount: snapshot.data![0].length,
                      itemBuilder: (context, index) {
                        List<Movie> movies = snapshot.data![0];
                        return FilmWidget(
                          filmRate: snapshot.data![0][index].filmRating,
                          filmTitle: snapshot.data![0][index].filmName,
                          filmImg: snapshot.data![0][index].imageLink,
                          overview: snapshot.data![0][index].overview,
                          id: snapshot.data![0][index].id,
                          origin: "home",
                        );
                      }),
                ));
          }
        });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<FilmWidget> allMovies;

  CustomSearchDelegate({required this.allMovies});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<FilmWidget> matchQuery = [];
    for (var movie in allMovies) {
      if (movie.filmTitle.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(movie);
      }
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.54),
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return result;
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<FilmWidget> matchQuery = [];
    for (var movie in allMovies) {
      if (movie.filmTitle.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(movie);
      }
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.54),
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return result;
      },
    );
  }
}
