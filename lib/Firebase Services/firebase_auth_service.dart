import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential?> googleSignin(BuildContext context) async {
    UserCredential? userCredential;
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          userCredential =
              await auth.signInWithCredential(credential);

        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            duration: const Duration(milliseconds: 3000),
          ));
        }

      } else {
        print("google acc is null");
      }
    } catch (e) {
      print("error while google sign in :- $e");
    }
    return userCredential;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      print('$e + Error while signing out');
    }
  }

  void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
