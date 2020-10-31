import 'dart:io';

import 'package:alice_store/models/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserData {

  String id;
  String email;
  String password;
  String name;
  String confirmPassword;
  bool admin = false;

  Address address;

  UserData({this.email, this.password, this.name, this.confirmPassword, this.id});

  UserData.fromDocument(DocumentSnapshot document){
    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
    if(document.data().containsKey('address')){
      address = Address.fromMap(document.data()['address'] as Map<String, dynamic>);
    }
  }

  DocumentReference get firestoreRef => FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');
  CollectionReference get tokensReference => firestoreRef.collection('tokens');

  //Método para salvar os dados do usuário no Firebase
  Future<void> saveData() async{
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
      if(address != null)
        'address': address.toMap(),
    };
  }

  void setAddress(Address address){
    this.address = address;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    await tokensReference.doc(token).set({
      'token': token,
      'updateAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }

}