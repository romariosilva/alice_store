import 'package:alice_store/models/home_manager.dart';
import 'package:alice_store/models/section.dart';
import 'package:flutter/material.dart';

class AddSectionWidget extends StatelessWidget {

  final HomeManager homeManager;

  const AddSectionWidget(this.homeManager);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: (){
              homeManager.addSection(Section(type: 'List'));
            }, 
            textColor: Colors.white,
            child: const Text('Adicinar Lista')
          )
        ),
        Expanded(
          child: FlatButton(
            onPressed: (){
              homeManager.addSection(Section(type: 'Staggered'));
            }, 
            textColor: Colors.white,
            child: const Text('Adicinar Grade')
          )
        ),
      ],
    );
  }
}