import 'package:alice_store/models/cart_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CheckoutManager  extends ChangeNotifier{

  CartManager cartManager;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager){
    this.cartManager = cartManager;
  }

  void checkout(){
    _decrementStock();

    _getOrderId().then((value) => print(value));
  }

  //Verifica as orders dos pedidos
  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try{
      final result = await firestore.runTransaction((tx) async{
        final doc = await tx.get(ref);
        final orderId = doc.data()['current'] as int;
        tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });

      return result['orderId'] ;
    } catch (e){
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  //Verifica o estoque e faz o decremento
  void _decrementStock(){
    //1. Ler todos os estoques
    //2. Decremento localmente os estoques
    //3. Salvar os estoques no firebase
  }

}