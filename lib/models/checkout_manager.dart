import 'package:alice_store/models/cart_manager.dart';
import 'package:alice_store/models/order.dart';
import 'package:alice_store/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CheckoutManager  extends ChangeNotifier{

  CartManager cartManager;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager){
    this.cartManager = cartManager;
  }

  Future<void> checkout({Function onStockFail}) async{
    try{
      await _decrementStock();
    } catch(e){
      onStockFail(e);
      return;
    }

    //TODO: PROCESSAR PAGAMENTO

    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();

    await order.save();
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
  Future<void> _decrementStock(){
    //1. Ler todos os estoques
    //2. Decremento localmente os estoques
    //3. Salvar os estoques no firebase

    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for(final cartProduct in cartManager.items){
        Product product;

        if(productsToUpdate.any((p) => p.idProduct == cartProduct.productId)){
          product = productsToUpdate.firstWhere((p) => p.idProduct == cartProduct.productId);
        } else {
          final doc = await tx.get(
            firestore.doc('products/${cartProduct.productId}')
          );
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);
        if(size.stock - cartProduct.quantity < 0){
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if(productsWithoutStock.isNotEmpty){
        return Future.error('${productsWithoutStock.length} produtos sem estoque');
      }

      for(final product in productsToUpdate){
        tx.update(
          firestore.doc('products/${product.idProduct}'), 
          {'sizes': product.exportSizeList()}
        );
      }
    });
  }

}