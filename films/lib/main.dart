import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:films/Constants.dart';
import 'package:films/authentication/signup.dart';
import 'package:films/firebase_options.dart';
import 'package:films/screens/details_page.dart';
import 'package:films/screens/favorite_movies.dart';
import 'package:films/screens/home_page.dart';
import 'package:films/authentication/login.dart';
import 'package:films/screens/profile_screen.dart';
import 'package:films/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print(
            '================================================================================User is currently signed out!');
      } else {
        await Constants().getUserUID();
        print(
            '================================================================================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FirebaseAuth.instance.currentUser != null ? HomePage() : Login(),
      debugShowCheckedModeBanner: false,
      routes: {
        "Home": (context) => HomePage(),
        "Login": (context) => Login(),
        "Signup": (context) => SignUp(),
        "Favorite": (context) => FavoriteScreen(),
        "Profile": (context) => ProfileScreen(),
      },
    );
  }
}

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if snapshot contains data (user is logged in)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Optional: loading indicator
        } else if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, redirect to home page
          return HomePage();
        } else {
          // No user is logged in, show login screen
          return Login();
        }
      },
    );
  }
}
