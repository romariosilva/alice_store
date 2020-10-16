import 'dart:async';

import 'package:alice_store/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'order.dart';

class AdminOrdersManager extends ChangeNotifier {

  List<Order> _orders = [];

  UserData userFilter;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}){
    _orders.clear();

    _subscription?.cancel();
    if(adminEnabled){
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').snapshots().listen(
      (event) {
        for(final change in event.docChanges){
          switch(change.type){
            case DocumentChangeType.added:
              _orders.add(
                Order.fromDocument(change.doc)
              );
              break;
            case DocumentChangeType.modified:
              final modOrder = _orders.firstWhere((o) => o.orderId == change.doc.id);
              modOrder.updateFromDocument(change.doc);
              break;
            case DocumentChangeType.removed:
              debugPrint('Deu problema sério!!!');
              break;
          }
        }
        notifyListeners();
    });
  }

  void setUserFilter(UserData user){
    userFilter = user;
    notifyListeners();
  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if(userFilter != null){
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    return output;
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

} 