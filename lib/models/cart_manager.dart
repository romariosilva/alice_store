import 'package:alice_store/models/cart_product.dart';
import 'package:alice_store/models/product.dart';
import 'package:alice_store/models/user_data.dart';
import 'package:alice_store/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartManager extends ChangeNotifier{

  List<CartProduct> items = [];

  UserData user;

  //Adcionar o produto ao carrinho, enviá-lo para o Firebase
  void addToCart(Product product){
    try{
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e){
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toCartItemMap()).then(
        (doc) => cartProduct.idDocument = doc.id
      );
    }
    notifyListeners();
  }

  //Remove um cart ao chegar em zero
  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.idDocument == cartProduct.idDocument);
    user.cartReference.doc(cartProduct.idDocument).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  // Adiciona a quantidade no Firebase
  void _onItemUpdated(){
    for(final cartProduct in items){
      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
      }

      _updateCartProduct(cartProduct);
    }
  }

  void _updateCartProduct(CartProduct cartProduct){
    user.cartReference.doc(cartProduct.idDocument).update(cartProduct.toCartItemMap());
  }

  //Método para ao mudar o usuário, poder carregar o cart deste
  void updateUser(UserManager userManager){
    user = userManager.user;
    items.clear();

    if(user != null){
      _loadCartItems();
    }
  }

  //Carrega os documentos do cart no Firebase
  Future<void> _loadCartItems() async{
    final QuerySnapshot cartSnap = await user.cartReference.get();

    items = cartSnap.docs.map(
      (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)
    ).toList();
  }

}