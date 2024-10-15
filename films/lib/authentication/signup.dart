import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:films/Constants.dart';
import 'package:films/authentication/login.dart';
import 'package:films/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/custombuttonauth.dart';
import 'components/customlogoauth.dart';
import 'components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

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
                    const Text("SignUp",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Container(height: 10),
                    const Text(
                        "After Signing in Check Your Email To Verify Your Account",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    Container(height: 20),
                    const Text(
                      "username",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(height: 10),
                    CustomTextForm(
                        validator: (val) {
                          if (val == '') {
                            return "Value can't be empty";
                          }
                        },
                        hintText: "ُEnter Your username",
                        myController: username,
                        secure: false),
                    Container(height: 20),
                    const Text(
                      "Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    SizedBox(height: 15)
                    // Container(
                    //   margin: const EdgeInsets.only(top: 10, bottom: 20),
                    //   alignment: Alignment.topRight,
                    //   child: const Text(
                    //     "Forgot Password ?",
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //     ),
                    //   ),
                    // ),
                  ])),
          CustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim());
                    if (userCredential.user != null) {
                      await userCredential.user!.sendEmailVerification();
                      Navigator.pushReplacementNamed(context, "Login"); }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'The password provided is too weak')
                          .show();
                    } else if (e.code == 'email-already-in-use') {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'The account already exists for that email')
                          .show();
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print("Not Valid");
                }
              }),
          Container(height: 20),
          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('Login');
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Have An Account ? ",
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
