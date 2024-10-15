import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Constants {
  static const apiKey = '0ffd462cdd720db4188f270fc3be6a3d';
  static const apiAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZmZkNDYyY2RkNzIwZGI0MTg4ZjI3MGZjM2JlNmEzZCIsInN1YiI6IjY2MmU4MjRhYTE5OWE2MDEyNTcyYTM2YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NpqL_2WtYdbf0N9lCL-Ig6Vvv1Oywmi3pnot_vnpeNg';

  Future<void> getUserUID() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Constants.favorites =
          await FirebaseFirestore.instance.doc("favourites/${currentUser.uid}");
    } else {
      throw Exception("User not logged in");
    }
  }

  Future<void> addUserFavorites() async {
    // Get the current user's unique ID
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Reference to the 'favourites' collection
      final CollectionReference favouritesCollection =
          FirebaseFirestore.instance.collection('favourites');
      // Reference to the user's document inside 'favourites'
      DocumentReference userDoc = favouritesCollection.doc(user.uid);
      // Check if the document already exists
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists == false) {
        // If document doesn't exist, create it and add the favorites list
        await userDoc.set({
          'favourites': [],
        }).catchError((error) {
          print("Failed to add user with favorites: $error");
        });
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  static late DocumentReference favorites;

  // static DocumentReference favorites =
  //     FirebaseFirestore.instance.doc("favourites/rGwRw34hNTaGKfU2L8RYgZ6jl4j2");

  // list of ids gotten from firebase
  static List<int> favIDs = [];

  // list of favorite movies ( widgets )
  static List<Widget> favMovies = [];

  // list to delete favorite
  static List<Widget> favoriteMovies = [];

  Future<void> deleteUserFavorites() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final DB = FirebaseFirestore.instance;
    await DB.collection("favourites").doc(currentUser!.uid).delete();
  }
}
