import 'package:alice_store/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductManager extends ChangeNotifier{

  ProductManager(){
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];

  String _search = '';
  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }

  //Método para filtrar os produtos
  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if(search.isEmpty){
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
        allProducts.where((p) => p.name.toLowerCase().contains(search.toLowerCase()))
      );
    }

    return filteredProducts;
  }

  //Função para carregar todos os produtos
  Future<void> _loadAllProducts() async{
    final QuerySnapshot snapProducts = await firestore.collection('products').get();

    allProducts = snapProducts.docs.map((d) => Product.fromDocument(d)).toList();

    notifyListeners();
  }

  //procura o produto pelo Id para ser vinculado ao home
  Product findProductById(String id){
    try{
      return allProducts.firstWhere((p) => p.idProduct == id);
    } catch(e){
      return null;
    }
  }

  void update(Product product){
    allProducts.removeWhere((p) => p.idProduct == product.idProduct);
    allProducts.add(product);
    notifyListeners();
  }

}