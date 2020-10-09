import 'package:alice_store/models/item_size.dart';
import 'package:alice_store/models/product.dart';
import 'package:flutter/material.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {

  final Product product;

  const SizesForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      builder: (state){
        return Column(
          children: state.value.map((size){
            return EditItemSize(
              size: size
            );
          }).toList(),
        );
      },
    );
  }
}