import 'package:alice_store/common/custom_drawer/custom_drawer.dart';
import 'package:alice_store/common/custom_icon_button.dart';
import 'package:alice_store/common/empty_card.dart';
import 'package:alice_store/common/order/order_tile.dart';
import 'package:alice_store/models/admin_orders_manager.dart';
import 'package:alice_store/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatelessWidget {

  final PanelController panelController = PanelController();

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
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: <Widget>[
                if(ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: (){
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if(filteredOrders.isEmpty)
                  const Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, index){
                        return OrderTile(
                          filteredOrders[index],
                          showControls: true,
                        );
                      }
                    ),
                  ),
                const SizedBox(height: 120),
              ],
            ),
            minHeight: 40,
            maxHeight: 240,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: (){
                    if(panelController.isPanelClosed){
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((s){
                      return CheckboxListTile(
                        title: Text(Order.getStatusText(s)),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                        value: ordersManager.statusFilter.contains(s), 
                        onChanged: (v){
                          ordersManager.setStatusFilter(
                            status: s,
                            enabled: v
                          );
                        }
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}