import 'package:alice_store/common/custom_drawer/custom_drawer.dart';
import 'package:alice_store/models/page_manager.dart';
import 'package:alice_store/models/user_manager.dart';
import 'package:alice_store/screens/admin_users/admin_users_screen.dart';
import 'package:alice_store/screens/home/home_screen.dart';
import 'package:alice_store/screens/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProductsScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home3'),
                ),
              ),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home4'),
                ),
              ),
              if(userManager.adminEnabled)
              //os ... adciona uma ista dentro de outra
              ...[
                AdminUsersScreen(),
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Home6'),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}