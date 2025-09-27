import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../data/services/platform_service.dart';

class PWAInstallWidget extends StatefulWidget {
  const PWAInstallWidget({super.key});

  @override
  State<PWAInstallWidget> createState() => _PWAInstallWidgetState();
}

class _PWAInstallWidgetState extends State<PWAInstallWidget> {
  bool _canInstall = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkInstallability();
  }

  Future<void> _checkInstallability() async {
    if (kIsWeb) {
      final canInstall = await PlatformService.instance.canInstallPWA();
      if (mounted) {
        setState(() {
          _canInstall = canInstall;
        });
      }
    }
  }

  Future<void> _installPWA() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await PlatformService.instance.installPWA();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Installation de l\'application lancée !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Installation non disponible. Utilisez le menu du navigateur.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || !_canInstall) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.get_app,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Installer l\'application',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Installez notre app sur votre appareil pour un accès rapide et une expérience optimisée.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _installPWA,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : const Icon(Icons.download, size: 20),
              label:
                  Text(_isLoading ? 'Installation...' : 'Installer maintenant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
