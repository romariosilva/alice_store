import 'package:alice_store/models/checkout_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodsCard extends StatefulWidget {

  @override
  _PaymentMethodsCardState createState() => _PaymentMethodsCardState();
}

class _PaymentMethodsCardState extends State<PaymentMethodsCard> {

  int selected = 1;

  @override
  Widget build(BuildContext context) {
    
    return Consumer<CheckoutManager>(
      builder: (_, checkoutManager, __){
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                RadioListTile(
                  title: const Text('Dinheiro na entrega'),
                  value: 1, 
                  groupValue: selected, 
                  onChanged: (int val){ 
                      setState(() {
                        selected = val;
                        checkoutManager.getPayment(selected);
                      });
                  },
                ),
                RadioListTile(
                  title: const Text('Cartão na entrega'),
                  value: 2, 
                  groupValue: selected, 
                  onChanged: (int val){
                      setState(() {
                        selected = val;
                        checkoutManager.getPayment(selected);
                      });
                  },
                  selected: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

