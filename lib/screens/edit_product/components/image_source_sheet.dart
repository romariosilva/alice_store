import 'package:flutter/material.dart';

class ImageSourceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: (){},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlatButton(
            onPressed: (){

            }, 
            child: const Text('Câmara')
          ),
          FlatButton(
            onPressed: (){

            }, 
            child: const Text('Gaeria')
          ),
        ],
      ),
    );
  }
}