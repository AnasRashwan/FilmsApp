import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:films/authentication/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    TextEditingController passwordController = TextEditingController();
    TextEditingController forgetPasswordController = TextEditingController();
    TextEditingController userController = TextEditingController();
    TextEditingController deleteUserEmailController = TextEditingController();
    TextEditingController deleteUserPasswordController =
        TextEditingController();
    TextEditingController changePasswordUserEmailController =
        TextEditingController();
    TextEditingController changePasswordUserPasswordController =
        TextEditingController();
    GlobalKey<FormState> key = GlobalKey();
    bool test = false;
    List<Map<String, dynamic>> details = [
      {
        "Text": "Change password",
        "Icon": Icon(Icons.change_circle),
        "Function": (String pass) async {
          try {
            if (user != null) {
              for (var userInfo in user.providerData) {
                // Case 1: User signed in with Google
                if (userInfo.providerId == 'google.com') {
                  print("User is signed in with Google.");

                  // Initiating Google Sign-In
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                  GoogleSignInAuthentication googleAuth =
                      await googleUser!.authentication;

                  // Reauthenticate with Google credential
                  AuthCredential credential = GoogleAuthProvider.credential(
                    idToken: googleAuth.idToken,
                    accessToken: googleAuth.accessToken,
                  );

                  await user.reauthenticateWithCredential(credential);

                  // Now update the password
                  await user.updatePassword(pass);

                  // Show success dialog after password is updated
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Success',
                          desc: 'Your Password has been updated successfully')
                      .show();

                  // Case 2: User signed in with email/password
                } else if (userInfo.providerId == 'password') {
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      body: Column(children: [
                        Form(
                          key: key,
                          child: Column(children: [
                            CustomTextForm(
                              hintText: "Enter Your Email",
                              myController: changePasswordUserEmailController,
                              secure: false,
                              validator: (val) {
                                if (val == '') {
                                  return "Email can't be empty";
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            CustomTextForm(
                              hintText: "Enter Your Password",
                              myController:
                                  changePasswordUserPasswordController,
                              secure: true,
                              validator: (val) {
                                if (val == '') {
                                  return "Password can't be empty";
                                }
                              },
                            ),
                          ]),
                        ),
                        MaterialButton(
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                try {
                                  // Reauthenticate with email/password credential
                                  AuthCredential credential =
                                      EmailAuthProvider.credential(
                                    email:
                                        changePasswordUserEmailController.text,
                                    password:
                                        changePasswordUserPasswordController
                                            .text,
                                  );

                                  await user
                                      .reauthenticateWithCredential(credential);

                                  // Now update the password
                                  await user.updatePassword(pass);

                                  // Show success dialog after password is updated
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Success',
                                          desc:
                                              'Your Password has been updated successfully')
                                      .show();
                                } on FirebaseAuthException catch (e) {
                                  // Handle different FirebaseAuthException codes
                                  if (e.code == 'user-not-found') {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc:
                                                'No user found for that email.')
                                        .show();
                                  } else if (e.code == 'wrong-password') {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc:
                                                'Wrong password provided for that user.')
                                        .show();
                                  } else if (e.code == 'invalid-credential') {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc:
                                                'Invalid credentials. Please check your email and password.')
                                        .show();
                                  } else {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc:
                                                'An error occurred. Please try again.')
                                        .show();
                                  }
                                }
                              } else {
                                print("Form is not valid.");
                              }
                            },
                            child: Text("Update Password",
                                style: TextStyle(color: Colors.blue)))
                      ])).show();
                }
              }
            }
          } catch (e) {
            print("Error: $e");
          }
        },
        "showField": false,
        "Controller": passwordController,
        "FieldText": "Enter Your New Password Here"
      },
      {
        "Text": "Forget Password",
        "Icon": Icon(Icons.password),
        "Function": (String h)async {
          FirebaseAuth auth = FirebaseAuth.instance;
          await auth.sendPasswordResetEmail(email: forgetPasswordController.text);
          AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Success',
              desc:
              'Please check your email and follow the link to change your password')
              .show();
        },
        "showField":false,
        "Controller" : forgetPasswordController,
        "FieldText":"Enter Your email here"
      },
      {
        "Text": "Delete User",
        "Icon": Icon(Icons.delete_forever),
        "Function": (String h) async {
          try {
            if (user != null) {
              for (var userInfo in user.providerData) {
                if (userInfo.providerId == 'google.com') {
                  print("User is signed in with Google.");
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                  GoogleSignInAuthentication googleAuth =
                      await googleUser!.authentication;

                  AuthCredential credential = GoogleAuthProvider.credential(
                    idToken: googleAuth.idToken,
                    accessToken: googleAuth.accessToken,
                  );
                  setState(() async {
                    await user.reauthenticateWithCredential(credential);
                    await Constants().deleteUserFavorites();
                    await user.delete();
                    await FirebaseAuth.instance.signOut();
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();
                    await Navigator.pushReplacementNamed(context, 'Login');
                  });

                  print(
                      "====================================User deleted successfully.");
                } else if (userInfo.providerId == 'password') {
                  print("User is signed in with Email and Password.");
                  await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          body: Column(children: [
                            Form(
                                key: key,
                                child: Column(children: [
                                  CustomTextForm(
                                      hintText: "Enter Your Email",
                                      myController: deleteUserEmailController,
                                      secure: false,
                                      validator: (val) {
                                        if (val == '') {
                                          return "Value can't be empty";
                                        }
                                      }),
                                  SizedBox(height: 10),
                                  CustomTextForm(
                                      hintText: "Enter Your Password",
                                      myController:
                                          deleteUserPasswordController,
                                      secure: true,
                                      validator: (val) {
                                        if (val == '') {
                                          return "Value can't be empty";
                                        }
                                      }),
                                ])),
                            MaterialButton(
                                onPressed: () async {
                                  if (key.currentState!.validate()) {
                                    try {
                                      final AuthCredential credential =
                                          EmailAuthProvider.credential(
                                        email: deleteUserEmailController.text,
                                        password:
                                            deleteUserPasswordController.text,
                                      );
                                      await user.reauthenticateWithCredential(
                                          credential);
                                      await Constants().deleteUserFavorites();
                                      await user.delete();
                                      Navigator.pushReplacementNamed(
                                          context, 'Login');
                                    } on FirebaseAuthException catch (e) {
                                      print(
                                          "Caught FirebaseAuthException: ${e.code}");
                                      if (e.code == 'user-not-found') {
                                        print(
                                            "No user found, showing dialog...");
                                        await AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.error,
                                                animType: AnimType.rightSlide,
                                                title: 'Error',
                                                desc:
                                                    'No user found for that email.')
                                            .show();
                                      } else if (e.code == 'wrong-password') {
                                        print(
                                            "Wrong password provided, showing dialog...");
                                        await AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.error,
                                                animType: AnimType.rightSlide,
                                                title: 'Error',
                                                desc:
                                                    'Wrong password provided for that user.')
                                            .show();
                                      } else if (e.code ==
                                          'invalid-credential') {
                                        print(
                                            "Invalid credentials provided, showing dialog...");
                                        await AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.error,
                                                animType: AnimType.rightSlide,
                                                title: 'Error',
                                                desc:
                                                    'Invalid credentials. Please check your email and password.')
                                            .show();
                                      } else {
                                        print("Unhandled error: ${e.message}");
                                        await AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.error,
                                                animType: AnimType.rightSlide,
                                                title: 'Error',
                                                desc:
                                                    'An error occurred. Please try again.')
                                            .show();
                                      }
                                    }
                                  } else {
                                    print("Form is not valid.");
                                  }
                                },
                                child: Text("Delete User",
                                    style: TextStyle(color: Colors.red)))
                          ]),
                          title: 'Error',
                          desc:
                              'Please check your email to verify the new email')
                      .show();
                }
              }
            }
          } catch (e) {
            print("Error: $e");
          }
        },
        "showField": false,
        "Controller": userController,
        "FieldText": "Are You Sure You Want to delete User? \nClick Save "
      }
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'Home');
                setState(() {});
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                  leading: details[index]['Icon'],
                  title: Text(
                    details[index]['Text'],
                    style: TextStyle(fontSize: 25),
                  ),
                  trailing: Icon(
                    details[index]['showField']
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                  ),
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      details[index]['showField'] = isExpanded;
                    });
                  },
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: details[index]['Controller'],
                            obscureText:
                                details[index]['Text'] == "Change password",
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: details[index]['FieldText']))),
                    MaterialButton(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 18),
                        ),
                        color: Colors.blueAccent,
                        onPressed: () {
                          String value = details[index]['Controller'].text;
                          details[index]['Function'](value);
                        }),
                    SizedBox(height: 20), // Add space after each entry
                  ]);
            }));
  }
}
