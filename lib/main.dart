import 'package:alice_store/models/admin_users_manager.dart';
import 'package:alice_store/models/cart_manager.dart';
import 'package:alice_store/models/home_manager.dart';
import 'package:alice_store/models/orders_manager.dart';
import 'package:alice_store/models/product.dart';
import 'package:alice_store/models/product_manager.dart';
import 'package:alice_store/models/user_manager.dart';
import 'package:alice_store/screens/address/address_screen.dart';
import 'package:alice_store/screens/base/base_screen.dart';
import 'package:alice_store/screens/cart/cart_screen.dart';
import 'package:alice_store/screens/checkout/checkout_screen.dart';
import 'package:alice_store/screens/edit_product/edit_product_screen.dart';
import 'package:alice_store/screens/login/login_screen.dart';
import 'package:alice_store/screens/product/product_screen.dart';
import 'package:alice_store/screens/select_product/select_product_screen.dart';
import 'package:alice_store/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Providers para que assim que o App inicie, esses arquivos iniciem juntos.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
            cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
            ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
            adminUsersManager..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alice Store',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen()
              );
              break;
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignUpScreen()
              );
              break;
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  settings.arguments as Product
                )
              );
              break;
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                settings: settings
              );
              break;
            case '/address':
              return MaterialPageRoute(
                builder: (_) => AddressScreen()
              );
              break;
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) => EditProductScreen(
                  settings.arguments as Product
                )
              );
              break;
            case '/select_product':
              return MaterialPageRoute(
                builder: (_) => SelectProductScreen()
              );
              break;
            case '/checkout':
              return MaterialPageRoute(
                builder: (_) => CheckoutScreen()
              );
              break;
            case '/base':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings
              );
          }
        },
      ),
    );
  }
}
