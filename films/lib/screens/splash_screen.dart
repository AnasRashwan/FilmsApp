import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:films/screens/home_page.dart';
import 'package:flutter/material.dart';

import '../models/api.dart';
import '../models/post.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late Future<List<Movie>> discoverMovies;
  // bool? adult;
  // String? posterImage;
  // int? id;
  // String? language;
  // String? title;
  // String? overview;
  // double? rate;

  // @override
  // void initState() {
  //   super.initState();
  //   discoverMovies = Api().getDiscoverMovies();
  // }

  @override
  Widget build(BuildContext context) {
    // CollectionReference DiscoverMovies =
    //     FirebaseFirestore.instance.collection('discoverMovies');

    // Future<void> addDiscoverMovies() {
    //   return DiscoverMovies.add({
    //     'adult': adult,
    //     'backdrop_path': posterImage,
    //     'id': id,
    //     'original_language': language,
    //     'original_title': title,
    //     'overview': overview,
    //     'vote_average': rate
    //   }).then((value) => print("Discover Movies Added")).catchError(
    //       (error) => print("Failed to add discover movies: $error"));
    // }

    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
          Container(
            width: 430,
            height: 500,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash_screen.jpeg'))),
          ),
          Text("    Watch\neverywhere",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(25)),
            child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text("Get Started",
                    style: TextStyle(fontSize: 25, color: Colors.white))),
          )
        ])));
  }
}
