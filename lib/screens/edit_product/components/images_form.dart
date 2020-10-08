import 'dart:io';

import 'package:alice_store/models/product.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {

  final Product product;

  const ImagesForm(this.product);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return FormField<List<dynamic>>(
      initialValue: product.images,
      builder: (state){
        return AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image){
                  return Stack(
                    children: [
                      if(image is String)
                        Image.network(image, fit: BoxFit.cover,)
                      else 
                        Image.file(image as File, fit: BoxFit.cover,),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.remove), 
                          color: Colors.red,
                          onPressed: (){
                            state.value.remove(image);
                            state.didChange(state.value);
                          }
                        ),
                      ),
                    ],
                  );
                }).toList()..add(
                  Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      color: primaryColor,
                      iconSize: 50,
                      onPressed: (){
                        showModalBottomSheet(
                          context: context, 
                          builder: (_) => ImageSourceSheet()
                        );
                      },
                    ),
                  ),
                ),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
        );
      },
    );
  }
}