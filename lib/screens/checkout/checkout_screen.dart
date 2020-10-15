import 'package:alice_store/common/price_card.dart';
import 'package:alice_store/models/cart_manager.dart';
import 'package:alice_store/models/checkout_manager.dart';
import 'package:alice_store/models/page_manager.dart';
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
            if(checkoutManager.loading){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    SizedBox(height: 16,),
                    Text(
                      'Processando seu pagamento...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              );
            }

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
                      },
                      onSuccess: (order){
                        Navigator.of(context).popUntil(
                          (route) => route.settings.name == '/base'
                        );
                        Navigator.of(context).pushNamed(
                          '/confirmation',
                          arguments: order
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