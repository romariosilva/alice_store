import 'package:alice_store/common/price_card.dart';
import 'package:alice_store/models/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/address_card.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true
      ),
      body: ListView(
        children: [
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __){
              return PriceCard(
                buttonText: 'Continuar para o Pagamento',
                onPressed: cartManager.isAddressValid ? (){
                  
                } : null,
              );
            }
          ),
        ],
      ),
    );
  }
}