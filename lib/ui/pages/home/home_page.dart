import '../home/widgets/index.dart';
import 'package:flutter/material.dart';
import '../_global_widgets/drawer.dart';
import '../_global_widgets/cart_icon.dart';
import '../_global_widgets/app_bar.dart';
import '../_global_widgets/pwa_install_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SiteAppBar(
        title: '🏠 Accueil',
        hasDrawer: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: const CartIcon(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HomeContainerIntro(),
            HomePaddingInfos(),
            HomeContainerCategories(),
            HomeContainerNewsletter(),
            SizedBox(height: 24),
            PWAInstallWidget(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
