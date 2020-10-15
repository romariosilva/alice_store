import 'package:alice_store/common/custom_drawer/custom_drawer.dart';
import 'package:alice_store/common/empty_card.dart';
import 'package:alice_store/models/admin_orders_manager.dart';
import 'package:alice_store/screens/orders/components/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __){
          if(ordersManager.orders.isEmpty){
            return const EmptyCard(
              title: 'Nenhuma venda realizada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_, index){
              return OrderTile(
                ordersManager.orders.reversed.toList()[index]
              );
            }
          );
        },
      ),
    );
  }
}