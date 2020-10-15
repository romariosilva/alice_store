import 'package:alice_store/common/price_card.dart';
import 'package:alice_store/models/cart_manager.dart';
import 'package:alice_store/models/checkout_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) => checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __){
            return ListView(
              children: [
                PriceCard(
                  buttonText: 'Finalizar Pedido',
                  onPressed: (){
                    checkoutManager.checkout(
                      onStockFail: (e){
                        Navigator.of(context).popUntil(
                          (route) => route.settings.name == '/cart'
                        );
                      }
                    );
                  },
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}