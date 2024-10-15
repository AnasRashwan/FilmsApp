import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:films/authentication/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Constants.dart';
import 'components/custombuttonauth.dart';
import 'components/customlogoauth.dart';
import 'components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController resetPassword = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    await Constants().addUserFavorites();
    Navigator.pushNamedAndRemoveUntil(context, "Home", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50),
                const CustomLogoAuth(),
                Container(height: 20),
                const Text("Login",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height: 10),
                const Text("Login To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == '') {
                        return "Value can't be empty";
                      }
                    },
                    hintText: "ُEnter Your Email",
                    myController: email,
                    secure: false),
                Container(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == '') {
                        return "Value can't be empty";
                      }
                    },
                    hintText: "ُEnter Your Password",
                    myController: password,
                    secure: true),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            animType: AnimType.rightSlide,
                            body: Column(children: [
                              CustomTextForm(
                                  hintText: "Enter Your Email",
                                  myController: resetPassword,
                                  secure: false,
                                  validator: (val) {
                                    if (val == '') {
                                      return "Value can't be empty";
                                    }
                                  }),
                              SizedBox(height: 20),
                              CustomButtonAuth(
                                  title: "Send Reset Email",
                                  onPressed: () async {
                                    FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: resetPassword.text);
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.rightSlide,
                                        title: 'Done',
                                        desc:
                                        'Email Reset Password has been sent to the email \n${resetPassword.text}')
                                        .show();
                                  })
                            ]),
                            title: 'Success',
                            desc:
                                'Please check your email and follow the link to change your password')
                        .show();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomButtonAuth(
            title: "login",
            onPressed: () async {
              if (formState.currentState!.validate()) {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                  if (credential.user!.emailVerified) {
                    await Constants().addUserFavorites();
                    Navigator.pushReplacementNamed(context, "Home");
                  } else {
                    print("User email not verified, showing dialog...");
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc:
                                'Please check your email and follow the link to verify your email.')
                        .show();
                  }
                } on FirebaseAuthException catch (e) {
                  print("Caught FirebaseAuthException: ${e.code}");

                  if (e.code == 'user-not-found') {
                    print("No user found, showing dialog...");
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'No user found for that email.')
                        .show();
                  } else if (e.code == 'wrong-password') {
                    print("Wrong password provided, showing dialog...");
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Wrong password provided for that user.')
                        .show();
                  } else if (e.code == 'invalid-credential') {
                    print("Invalid credentials provided, showing dialog...");
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
                            desc: 'An error occurred. Please try again.')
                        .show();
                  }
                }
              } else {
                print("Form is not valid.");
              }
            },
          ),
          Container(height: 20),
          MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: () {
                signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset("assets/images/googleLogo.png", width: 20)
                ],
              )),
          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('Signup');
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(text: "Don't Have An Account ? "),
                TextSpan(
                    text: "Register",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold))
              ])),
            ),
          )
        ]),
      ),
    );
  }
}


