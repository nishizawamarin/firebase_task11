import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_task1/firebase_auth_service.dart';
import 'package:firebase_task1/sign_in.dart';
import 'package:firebase_task1/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthExercise extends StatefulWidget {
  const AuthExercise({Key? key}) : super(key: key);

  @override
  State<AuthExercise> createState() => _AuthExerciseState();
}

class _AuthExerciseState extends State<AuthExercise> {
  bool _isSignedIn = false;
  String _userMail = '';

  void checkSignInState(){
    FirebaseAuthService()
        .authStateChanges()
        .listen((User? user) {
      if (user != null) {
        _userMail = user.email!;
        setState(() {
          _isSignedIn = true;
        });
      } else {
        setState(() {
          _isSignedIn = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    checkSignInState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: _isSignedIn?SignInSucced(userMail:_userMail):const SignUp(),
    );
  }
}


