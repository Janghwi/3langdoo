import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  // ignore: prefer_final_fields
  var _googleSignIn = GoogleSignIn();

  var user = Rx<GoogleSignInAccount?>(null);

  // Rx<GoogleSignInAccount?> get user => _user;

  googleLogin() async {
    user.value = await _googleSignIn.signIn();
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      user = googleUser as Rx<GoogleSignInAccount?>;
      // user = googleUser as Rx<GoogleSignInAccount?>;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  logout() async {
    user.value = await _googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    //   await _googleSignIn.disconnect();
    //   FirebaseAuth.instance.signOut();
    // }
  }
}
