import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/cart_page.dart';
import 'pages/catalog_page.dart';
import 'pages/checkout_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/orders_page.dart';
import 'pages/product_page.dart';
import 'pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const MyHomePage(),
        '/catalog': (_) => const CatalogPage(),
        '/cart': (_) => const CartPage(),
        '/checkout': (_) => const CheckoutPage(),
        '/orders': (_) => const OrdersPage(),
        '/product/:name': (_) => const ProductPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}
