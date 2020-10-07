import 'package:alice_store/models/cart_product.dart';
import 'package:alice_store/models/product.dart';

class CartManager {

  List<CartProduct> items = [];

  //Adcionar o produto ao carrinho
  void addToCart(Product product){
    items.add(CartProduct.fromProduct(product));
  }

}