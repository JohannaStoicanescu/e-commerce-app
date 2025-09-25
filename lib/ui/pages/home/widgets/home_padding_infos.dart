import 'package:flutter/material.dart';

class HomePaddingInfos extends StatelessWidget {
    const HomePaddingInfos({super.key});
    
    @override
    Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Pourquoi choisir E-COMMERCE APP ?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.local_shipping_rounded,
                      title: 'Livraison Gratuite',
                      subtitle: 'Dès 50€ d\'achat',
                      color: const Color(0xFF28A745),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.verified_rounded,
                      title: 'Qualité Premium',
                      subtitle: 'Matériaux sélectionnés',
                      color: const Color(0xFF667EEA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.support_agent_rounded,
                      title: 'Service Client',
                      subtitle: '7j/7 - 24h/24',
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.refresh_rounded,
                      title: 'Retour Facile',
                      subtitle: '30 jours pour changer d\'avis',
                      color: const Color(0xFF6F42C1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
    }

    Container _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6C757D),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}