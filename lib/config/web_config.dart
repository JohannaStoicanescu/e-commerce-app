import 'package:flutter/foundation.dart';

class WebConfig {
  static void configureApp() {
    if (kIsWeb) {
      // Disable optimizations that cause type casting issues
      debugPrint('Configuring for Web platform');
    }
  }
}
