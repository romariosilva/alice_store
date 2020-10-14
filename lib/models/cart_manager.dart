import 'package:alice_store/models/cart_product.dart';
import 'package:alice_store/models/product.dart';
import 'package:alice_store/models/user_data.dart';
import 'package:alice_store/models/user_manager.dart';
import 'package:alice_store/service/cepaberto_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:alice_store/models/address.dart';
import 'package:geolocator/geolocator.dart';

class CartManager extends ChangeNotifier{

  List<CartProduct> items = [];

  UserData user;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      _onItemUpdated();
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
    productsPrice = 0.0;

    for(int i=0; i<items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct){
    if(cartProduct.idDocument != null)
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

  //Verificando se tem estoqe suficiente
  bool get isCartValid{
    for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  // ADDRESS

  Future<void> getAddress(String cep) async{
    final cepAbertoService = CepAbertoService();

    try{
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);
      
      if(cepAbertoAddress != null){
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude
        );
        notifyListeners();
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> setAddress(Address address) async{
    this.address = address;

    if(await calculateDelivery(address.lat, address.long)){
      print('price $deliveryPrice');
    } else {
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  void removeAddress(){
    address = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async{
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    final latStore = doc.data()['lat'] as double;
    final longStore = doc.data()['long'] as double;
    final maxKm = doc.data()['maxKm'] as num;
    final base = doc.data()['base'] as num;
    final km = doc.data()['km'] as num;

    double dis = await distanceBetween(latStore, longStore, lat, long);
    dis /= 1000.0; //Convertendo para kilômetros

    debugPrint('Distância $dis'); 

    if(dis > maxKm){
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;
  }

}