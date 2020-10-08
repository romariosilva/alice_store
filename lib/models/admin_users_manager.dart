import 'dart:async';

import 'package:alice_store/models/user_data.dart';
import 'package:alice_store/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminUsersManager extends ChangeNotifier{

  List<UserData> users = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateUser(UserManager userManager){
    _subscription?.cancel();
    if(userManager.adminEnabled){
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  //Buscando todos os usuários
  void _listenToUsers(){
    _subscription = firestore.collection('users').snapshots().listen((snapshot){
      users = snapshot.docs.map((e) => UserData.fromDocument(e)).toList();
      users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  //Pegando o nome dos usuários
  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    // O '?' significa que se o _subscription for null então não chama o cancel
    _subscription?.cancel();
    super.dispose();
  }

}