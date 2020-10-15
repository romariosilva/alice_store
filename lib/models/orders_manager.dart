import 'dart:async';

import 'package:alice_store/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'order.dart';

class OrdersManager extends ChangeNotifier {

  UserData user;

  List<Order> orders = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateUser(UserData user){
    this.user = user;
    orders.clear();

    _subscription?.cancel();
    if(user != null){
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').where('user', isEqualTo: user.id)
        .snapshots().listen(
    (event) {
      orders.clear();
      for(final doc in event.docs){
        orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

} 