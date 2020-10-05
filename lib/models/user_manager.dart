import 'package:alice_store/helpers/firebase_errors.dart';
import 'package:alice_store/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManager {

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn({UserData user, Function onFail, Function onSuccess}) async{
    try{
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: user.email, 
        password: user.password
      );

      onSuccess();
    } on FirebaseAuthException catch (e){
      onFail(getErrorString(e.code));   
    }
  }

}