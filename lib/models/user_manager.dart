import 'package:alice_store/helpers/firebase_errors.dart';
import 'package:alice_store/models/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserManager  extends ChangeNotifier{

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  User user;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  // Função para fazer o login na tela e tratamento de erros
  Future<void> signIn({UserData user, Function onFail, Function onSuccess}) async{
    loading = true;
    try{
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: user.email, 
        password: user.password
      );

      this.user = result.user;

      onSuccess();
    } on FirebaseAuthException catch (e){
      onFail(getErrorString(e.code));   
    }
    loading = false;
  }

  //método para quando o usuário já estiver logado, entrar logo
  Future<void> _loadCurrentUser() async {
    final User currentUser = auth.currentUser;
    if(currentUser != null){
      user = currentUser;
      print(user.uid);
    }
    notifyListeners();
  }

}