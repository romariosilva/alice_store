import 'package:alice_store/models/item_size.dart';
import 'package:alice_store/models/product.dart';

class CartProduct {

  String productId;
  int quantity;
  String size;

  Product product;

  CartProduct.fromProduct(this.product){
    productId = product.idProduct;
    quantity = 1;
    size = product.selectedSize.name;
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

}