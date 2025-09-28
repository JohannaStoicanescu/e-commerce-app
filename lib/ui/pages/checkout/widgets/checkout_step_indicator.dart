import 'package:flutter/material.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final int _currentStep;

  const CheckoutStepIndicator({super.key, required int currentStep})
      : _currentStep = currentStep;

  @override
  Container build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStepItem(0, Icons.receipt_long),
          _buildStepConnector(),
          _buildStepItem(1, Icons.local_shipping),
          _buildStepConnector(),
          _buildStepItem(2, Icons.payment),
          _buildStepConnector(),
          _buildStepItem(3, Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, IconData icon) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive || isCompleted
                  ? const Color(0xFF667EEA)
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: isActive || isCompleted ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey[300],
      ),
    );
  }
}
