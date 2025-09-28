import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'services/error_handler.dart';
import 'config/web_config.dart';
import 'widgets/error_boundary.dart';
import 'ui/pages/cart/cart_page.dart';
import 'ui/pages/checkout/checkout_page.dart';
import 'ui/pages/home/home_page.dart';
import 'ui/pages/login/login_page.dart';
import 'ui/pages/orders/orders_page.dart';
import 'ui/pages/product/product_page.dart';
import 'ui/pages/products/products_page.dart';
import 'ui/pages/register/register_page.dart';
import 'ui/viewmodels/products_viewmodel.dart';
import 'ui/viewmodels/cart_viewmodel.dart';
import 'ui/viewmodels/orders_viewmodel.dart';
import 'ui/viewmodels/checkout_viewmodel.dart';

import 'data/services/auth_service.dart';
import 'data/services/payment_service.dart';
import 'data/models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorHandler.initialize();
  WebConfig.configureApp();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    PaymentService.init();
  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => ProductsViewModel()),
          ChangeNotifierProvider(create: (_) => CartViewModel()),
          ChangeNotifierProvider(create: (_) => OrdersViewModel()),
          ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
        ],
        child: MaterialApp(
          title: 'E Commerce App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            useMaterial3: true,
            textTheme: GoogleFonts.robotoTextTheme(),
          ),
          initialRoute: '/',
          routes: {
            '/': (_) => const MyHomePage(),
            '/cart': (_) => const CartPage(),
            '/checkout': (_) => const CheckoutPage(),
            '/product': (_) => const ProductsPage(),
            '/orders': (_) => const OrdersPage(),
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
          },
          onGenerateRoute: (RouteSettings settings) {
            final uri = Uri.parse(settings.name ?? '');

            if (settings.name == '/products' ||
                (uri.pathSegments.isNotEmpty &&
                    uri.pathSegments.first == 'products')) {
              final category = uri.queryParameters['category'];
              return MaterialPageRoute(
                builder: (_) => ProductsPage(initialCategory: category),
                settings: settings,
              );
            }

            if (uri.pathSegments.length == 2 &&
                uri.pathSegments.first == 'product') {
              final slug = uri.pathSegments[1];

              final product = settings.arguments as Product?;

              if (product == null) {
                return MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Produit introuvable')),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text('Aucun produit fourni pour "$slug".'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false),
                            child: const Text('Retour à l\'accueil'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  settings: settings,
                );
              }

              return MaterialPageRoute<void>(
                builder: (_) => ProductPage(product: product),
                settings: settings,
              );
            }

            return MaterialPageRoute<void>(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Page non trouvée')),
                body: Center(child: Text('Route inconnue : ${settings.name}')),
              ),
              settings: settings,
            );
          },
        ),
      ),
    );
  }
}
