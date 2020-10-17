import 'package:alice_store/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StoresManager extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Store> stores = [];

  StoresManager(){
    _loadStoreList();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('store').get();

    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();

    notifyListeners();
  }

} 