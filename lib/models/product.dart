import 'package:alice_store/models/item_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Product extends ChangeNotifier{

  String idProduct;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  //Verificar o tamanho selecionado
  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value){
    _selectedSize = value;
    notifyListeners();
  }

  Product.fromDocument(DocumentSnapshot document){
    idProduct = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    sizes = (document.data()['sizes'] as List<dynamic> ?? []).map(
      (s) => ItemSize.fromMap(s as Map<String, dynamic>)
    ).toList();
  }

  //Pega a soma de todo o stock
  int get totalStock {
    int stock = 0;
    for(final size in sizes){
      stock += size.stock;
    }
    return stock;
  }

  //Verifica se tem stock
  bool get hasStock {
    return totalStock > 0;
  }

}