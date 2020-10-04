import 'package:alice_store/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class UserManager {

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn(UserData user) async{
    try{
      final result = await auth.signInWithEmailAndPassword(email: user.email, password: user.password);

      print(result.user.uid);
    }on PlatformException catch (e){
      print(e);
    }
  }

}