// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  Future SignInEmailPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future SignUpEmailPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future? ResetPassword(String email) {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
