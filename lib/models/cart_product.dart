import 'package:alice_store/models/item_size.dart';
import 'package:alice_store/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartProduct extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idDocument;

  String productId;
  int quantity;
  String size;

  num fixedPrice;

  Product _product;
  Product get product => _product;
  set product(Product value){
    _product = value;
    notifyListeners();
  }

  CartProduct.fromProduct(this._product){
    productId = product.idProduct;
    quantity = 1;
    size = product.selectedSize.name;
  }

  //Buscando o cart do usuário no Firebase
  CartProduct.fromDocument(DocumentSnapshot document){
    idDocument = document.id;
    productId = document.data()['pid'] as String;
    quantity = document.data()['quantity'] as int;
    size = document.data()['size'] as String;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
      }
    );
  }

  CartProduct.fromMap(Map<String, dynamic> map){
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
      }
    );
  }

  ItemSize get itemSize {
    if(product == null) return null;
    return product.findSize(size);
  }

  //Preço unitário do tamanho
  num get unitPrice {
    if(product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap(){
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size
    };
  }

   Map<String, dynamic> toOrderItemMap(){
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice
    };
  }

  //Método que verifica se pode juntar no mesmo card um produto se tiver o mesmo tamanho e ID
  bool stackable(Product product){
    return product.idProduct == productId && product.selectedSize.name == size;
  }

  //aumentar a quantidade
  void increment(){
    quantity++;
    notifyListeners();
  }

  //diminuir a quantidade
  void decrement(){
    quantity--;
    notifyListeners();
  }

  //Verificando se tem estoque
  bool get hasStock {
    final size = itemSize;
    if(size == null) return false;
    return size.stock >= quantity;
  }

}