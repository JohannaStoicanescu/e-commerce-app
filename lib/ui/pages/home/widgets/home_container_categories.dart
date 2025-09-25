import 'package:flutter/material.dart';

class HomeContainerCategories extends StatelessWidget {
  const HomeContainerCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          const Text(
            'Nos Catégories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildCategoryCard(
                context,
                title: 'Vêtements Femme',
                icon: Icons.checkroom_rounded,
                color: const Color(0xFFE91E63),
                category: 'women\'s clothing',
              ),
              _buildCategoryCard(
                context,
                title: 'Vêtements Homme',
                icon: Icons.man_rounded,
                color: const Color(0xFF2196F3),
                category: 'men\'s clothing',
              ),
              _buildCategoryCard(
                context,
                title: 'Bijoux',
                icon: Icons.diamond_rounded,
                color: const Color(0xFFFF9800),
                category: 'jewelery',
              ),
              _buildCategoryCard(
                context,
                title: 'Électronique',
                icon: Icons.devices_rounded,
                color: const Color(0xFF4CAF50),
                category: 'electronics',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildCategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String category,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(
            context,
            '/products?category=${Uri.encodeComponent(category)}',
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
