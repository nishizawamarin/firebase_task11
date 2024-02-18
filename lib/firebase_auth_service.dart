import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_task1/sign_up.dart';
import 'package:firebase_task1/sign_in.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
      {required email, required password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      {required email, required password}) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
