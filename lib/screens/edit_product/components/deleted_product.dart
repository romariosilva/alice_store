import 'package:alice_store/models/product.dart';
import 'package:alice_store/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeletedProduct extends StatelessWidget {

  final Product product;

  const DeletedProduct(this.product);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Excluir o produto ${product.name}?'),
      content: const Text('Cuidado!!! Esta ação não poderá ser defeita!'),
      actions: [
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
            context.read<ProductManager>().delete(product);
            Navigator.of(context).popUntil(
              (route) => route.settings.name == '/'
            );
          },
          textColor: Colors.red, 
          child: const Text('Excluir')
        ),
      ],
    );
  }
}