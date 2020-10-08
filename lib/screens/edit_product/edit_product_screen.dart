import 'package:alice_store/models/product.dart';
import 'package:flutter/material.dart';

import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {

  final Product product;

  const EditProductScreen(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true
      ),
      body: ListView(
        children: [
          ImagesForm(product),
        ],
      ),
    );
  }
}