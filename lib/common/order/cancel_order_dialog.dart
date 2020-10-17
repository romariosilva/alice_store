import 'package:alice_store/models/order.dart';
import 'package:flutter/material.dart';

class CancelOrderDialog extends StatelessWidget {

  const CancelOrderDialog(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId}?'),
      content: const Text('Esta ação não poderá ser defeita!'),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: const Text('Cancelar')
        ),
        FlatButton(
          onPressed: (){
            order.cancel();
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Cancelar Pedido'),
        ),
      ],
    );
  }
}