import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductManager {

  ProductManager(){
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Função para carregar todos os produtos
  Future<void> _loadAllProducts() async{
    final QuerySnapshot snapProducts = await firestore.collection('products').get();

    for(DocumentSnapshot doc in snapProducts.docs){
      print(doc.data());
    }
  }

}