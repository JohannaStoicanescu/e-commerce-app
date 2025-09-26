import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformService {
  static PlatformService? _instance;
  static PlatformService get instance => _instance ??= PlatformService._();

  PlatformService._();

  // Platform detection helpers
  bool get isWeb => kIsWeb;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isMobile => isAndroid || isIOS;

  // PWA Installation for Web
  static const MethodChannel _webChannel = MethodChannel('web/platform');

  Future<bool> canInstallPWA() async {
    if (!isWeb) return false;
    try {
      // Check if the app can be installed (beforeinstallprompt event)
      final bool? canInstall = await _webChannel.invokeMethod('canInstall');
      return canInstall ?? false;
    } catch (e) {
      // Fallback: assume PWA can be installed on web
      return isWeb;
    }
  }

  Future<void> installPWA() async {
    if (!isWeb) return;
    try {
      await _webChannel.invokeMethod('install');
    } catch (e) {
      debugPrint('PWA installation not supported: $e');
      // Fallback: show instructions
      _showInstallInstructions();
    }
  }

  void _showInstallInstructions() {
    // This would show a dialog with manual installation instructions
    debugPrint(
        'PWA Manual Installation: Use browser menu to "Add to Home Screen"');
  }

  // Share functionality (mainly for Android/iOS)
  Future<void> shareProduct({
    required String productName,
    required String productDescription,
    required double price,
    String? imageUrl,
  }) async {
    final String shareText = '''
🛍️ Découvrez ce produit incroyable !

$productName
💰 ${price.toStringAsFixed(2)} €

$productDescription

Achetez maintenant sur notre app E-Commerce !
    '''
        .trim();

    try {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Share with image (requires network image download for mobile)
        await Share.share(
          shareText,
          subject: 'Produit: $productName',
        );
      } else {
        await Share.share(
          shareText,
          subject: 'Produit: $productName',
        );
      }
    } catch (e) {
      debugPrint('Share failed: $e');
    }
  }

  Future<void> shareOrder({
    required String orderId,
    required double totalAmount,
    required List<String> productNames,
  }) async {
    final String productsText = productNames.join(', ');
    final String shareText = '''
🎉 Commande confirmée !

📦 Commande #$orderId
💰 Total: ${totalAmount.toStringAsFixed(2)} €
🛍️ Produits: $productsText

Merci pour votre achat !
    '''
        .trim();

    try {
      await Share.share(
        shareText,
        subject: 'Commande confirmée #$orderId',
      );
    } catch (e) {
      debugPrint('Share failed: $e');
    }
  }

  // Open external links
  Future<void> openUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: isWeb
              ? LaunchMode.platformDefault
              : LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('Failed to open URL: $e');
    }
  }

  // Platform-specific UI helpers
  bool shouldUseCupertinoStyle() {
    return isIOS;
  }

  EdgeInsets getPlatformPadding() {
    if (isIOS) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    } else if (isAndroid) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double getPlatformButtonHeight() {
    if (isIOS) {
      return 44.0;
    } else if (isAndroid) {
      return 48.0;
    } else {
      return 56.0;
    }
  }
}
