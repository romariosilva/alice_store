import 'package:alice_store/models/product.dart';
import 'package:alice_store/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/deleted_product.dart';
import 'components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {

  final Product product;
  final bool editing;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  EditProductScreen(Product p) : 
  editing = p != null,
  product = p != null ? p.clone() : Product();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
          actions: [
            if(editing)
            IconButton(
              icon: const Icon(Icons.delete), 
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (_) => DeletedProduct(product)
                );
              }
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formkey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                      validator: (name){
                        if(name.length < 6)
                          return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name, 
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(
                        fontSize: 16
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none
                      ),
                      maxLines: null,
                      validator: (desc){
                        if(desc.length < 10)
                          return 'Descrição muito curto';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product),
                    const SizedBox(height: 20),
                    Consumer<Product>(
                      builder: (_, product, __){
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: !product.loading ? () async{
                              if(formkey.currentState.validate())
                                formkey.currentState.save();
                                
                                await product.save();

                                context.read<ProductManager>().update(product);

                                Navigator.of(context).pop();
                            } : null,
                            textColor: Colors.white,
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                            child: product.loading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                            : const Text('Salvar', style: TextStyle(fontSize: 18.0),),
                          ),
                        );                      
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}