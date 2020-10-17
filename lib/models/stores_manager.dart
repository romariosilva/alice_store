import 'dart:async';

import 'package:alice_store/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StoresManager extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Store> stores = [];

  Timer _timer;

  StoresManager(){
    _loadStoreList();
    _startTimer();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('store').get();

    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();

    notifyListeners();
  }

  void _startTimer(){
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening(){
    for(final store in stores)
      store.updateStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

} 