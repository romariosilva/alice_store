import 'package:alice_store/helpers/firebase_errors.dart';
import 'package:alice_store/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserManager extends ChangeNotifier{

  UserManager(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserData user;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  // Função para fazer o login na tela e tratamento de erros
  Future<void> signIn({UserData user, Function onFail, Function onSuccess}) async{
    loading = true;
    try{
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: user.email, 
        password: user.password
      );

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on FirebaseAuthException catch (e){
      onFail(getErrorString(e.code));   
    }
    loading = false;
  }

  //Função para fazer o cadastro
  Future<void> signUp({UserData user, Function onFail, Function onSuccess}) async{
    loading = true;
    try{
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: user.email, 
        password: user.password
      );

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();

      onSuccess();
    } on FirebaseAuthException catch(e){
      onFail(getErrorString(e.code));
    }
  }

  void signOutApp(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  //método para quando o usuário já estiver logado, entrar logo
  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? auth.currentUser;
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();

      user = UserData.fromDocument(docUser);
      
      notifyListeners();
    }
    
  }

}