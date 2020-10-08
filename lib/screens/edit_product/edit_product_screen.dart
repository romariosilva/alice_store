import 'package:alice_store/models/product.dart';
import 'package:flutter/material.dart';

import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {

  final Product product;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  EditProductScreen(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            ImagesForm(product),
            RaisedButton(
              onPressed: (){
                if(formkey.currentState.validate())
                  print('Válido!!');
              },
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}