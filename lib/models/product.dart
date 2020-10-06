import 'package:alice_store/models/item_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {

  String idProduct;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  Product.fromDocument(DocumentSnapshot document){
    idProduct = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
    sizes = (document.data()['sizes'] as List<dynamic> ?? []).map(
      (s) => ItemSize.fromMap(s as Map<String, dynamic>)
    ).toList();
    print(sizes);
  }

}