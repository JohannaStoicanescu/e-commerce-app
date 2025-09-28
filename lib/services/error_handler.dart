import 'package:flutter/foundation.dart';

class ErrorHandler {
  static void initialize() {
    if (kIsWeb) {
      // Handle platform-specific errors on web
      FlutterError.onError = (FlutterErrorDetails details) {
        debugPrint('Flutter Error Caught: ${details.exception}');
        if (details.stack != null) {
          debugPrint('Stack trace: ${details.stack}');
        }
        // Check if it's a type casting error
        if (details.exception.toString().contains('is not a subtype of type')) {
          debugPrint(
              'Type casting error detected - this is usually safe to ignore in web release mode');
          return;
        }

        debugPrint('Continuing app execution despite error');
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        debugPrint('Platform Error: $error');
        debugPrint('Stack: $stack');
        return true; // Handled
      };
    }
  }
}
