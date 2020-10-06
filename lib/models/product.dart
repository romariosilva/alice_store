import 'package:cloud_firestore/cloud_firestore.dart';

class Product {

  String idProduct;
  String name;
  String description;
  List<String> images;

  Product.fromDocument(DocumentSnapshot document){
    idProduct = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data()['images'] as List<dynamic>);
  }

}