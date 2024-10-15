import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:films/screens/home_page.dart';
import 'package:films/widgets/film_widget.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../models/api.dart';
import '../models/post.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Widget>> FavoriteMovies;

  @override
  void initState() {
    // TODO: implement initState
    Constants.favIDs.clear();
    Constants.favMovies.clear();
    FavoriteMovies = Api().getFavoriteMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("FavoriteMovies"),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
                setState(() {});
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: FutureBuilder(
            future: FavoriteMovies,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.54),
                    itemCount: Constants.favIDs.length,
                    itemBuilder: (context, index) {
                      return Constants.favMovies[index];
                    });
              }
            }));
  }
}
// FutureBuilder(
// future: favMovies.doc().get(),
// builder: (context, snapshot) {
// if (snapshot.hasError) {
// return Center(child: Text(snapshot.error.toString()));
// } else if (!snapshot.hasData) {
// return Center(
// child: Text("No Favorite Movies",
// style: TextStyle(fontSize: 45)));
// } else {
// return
// }
