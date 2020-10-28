import 'package:alice_store/models/address.dart';
import 'package:alice_store/models/cart_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_manager.dart';

enum Status { canceled, preparing, transporting, delivered }

class Order {

  String orderId;
  String payment;

  List<CartProduct> items;
  num price;

  String userId;

  Address address;

  Timestamp date;

  Status status;

  String get formattedId => '#${orderId.padLeft(6, '0')}';
  String get statusText => getStatusText(status);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef => firestore.collection('orders').doc(orderId);

  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.id;

    items = (doc.data()['items'] as List<dynamic>).map((e){
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.data()['price'] as num;
    userId = doc.data()['user'] as String;
    address = Address.fromMap(doc.data()['address'] as Map<String, dynamic>);
    date = doc.data()['date'] as Timestamp;

    status = Status.values[doc.data()['status'] as int];
    payment = doc.data()['payment'] as String;
  }

  void updateFromDocument(DocumentSnapshot doc){
    status = Status.values[doc.data()['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items': items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address.toMap(),
        'status': status.index,
        'date': Timestamp.now(),
        'payment': payment
      }
    );
  }

  static String getStatusText(Status status) {
    switch(status){
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  //Voltar um status
  Function() get back {
    return status.index >= Status.transporting.index ?
      (){
        status = Status.values[status.index - 1];
        firestoreRef.update({'status': status.index});
      } : null;
  }
  
  //Avançar um status
  Function() get advance {
    return status.index <= Status.transporting.index ?
      (){
        status = Status.values[status.index + 1];
        firestoreRef.update({'status': status.index});
      } : null;
  }

  //Cancelar pedido
  void cancel(){
    status = Status.canceled;
    firestoreRef.update({'status': status.index});
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }

}