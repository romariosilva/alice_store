import 'package:alice_store/common/custom_drawer/custom_drawer.dart';
import 'package:alice_store/models/stores_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Lojas'),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __){
          return Container();
        },
      ),
    );
  }
}