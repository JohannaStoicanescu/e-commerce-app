import '../checkout/widgets/index.dart';
import '../cart/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../_global_widgets/drawer.dart';
import '../_global_widgets/app_bar.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/checkout_viewmodel.dart';
import '../../../data/models/order.dart';
import '../../../data/services/payment_service.dart';
import '../../../data/services/auth_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _fullNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'France');
  final _phoneController = TextEditingController();

  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  final _emailController = TextEditingController();
  final _billingPhoneController = TextEditingController();

  final _shippingFormKey = GlobalKey<FormState>();
  final _billingFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cardNumberController.text = '4000 0000 0000 0002';
    _cardExpiryController.text = '12/28';
    _cardCvvController.text = '123';
    _cardNameController.text = 'John Doe';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _emailController.dispose();
    _billingPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteAppBar(
        title: '💳 Finaliser la commande',
        hasDrawer: true,
      ),
      drawer: const AppDrawer(),
      body: Consumer2<CartViewModel, AuthService>(
        builder: (context, cartViewModel, authService, child) {
          if (!authService.isLoggedIn) {
            return CartNotLoggedIn();
          }
          
          return _buildCheckoutFlow(cartViewModel);
        },
      ),
    );
  }

  Widget _buildCheckoutFlow(CartViewModel cartViewModel) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
        ),
      ),
      child: Column(
        children: [
          CheckoutStepIndicator(currentStep: _currentStep),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildOrderSummaryStep(cartViewModel),
                _buildShippingStep(),
                _buildPaymentStep(cartViewModel),
                _buildConfirmationStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryStep(CartViewModel cartViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Récapitulatif de votre commande',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cartViewModel.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartViewModel.cartItems[index];
                return CheckoutOrderItems(item: item);
              },
            ),
          ),
          CheckoutOrderTotal(cartViewModel: cartViewModel),
          const SizedBox(height: 20),
          CheckoutNavigationButtons(
            onNext: () => _nextStep(),
            showBack: false,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _shippingFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adresse de livraison',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CheckoutTextField(
                      controller: _fullNameController,
                      label: 'Nom complet',
                      icon: Icons.person,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 16),
                    CheckoutTextField(
                      controller: _streetController,
                      label: 'Adresse',
                      icon: Icons.home,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CheckoutTextField(
                            controller: _cityController,
                            label: 'Ville',
                            icon: Icons.location_city,
                            validator: (value) => value?.isEmpty == true
                                ? 'Ce champ est requis'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CheckoutTextField(
                            controller: _postalCodeController,
                            label: 'Code postal',
                            icon: Icons.markunread_mailbox,
                            keyboardType: TextInputType.number,
                            validator: (value) => value?.isEmpty == true
                                ? 'Ce champ est requis'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CheckoutTextField(
                      controller: _countryController,
                      label: 'Pays',
                      icon: Icons.public,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 16),
                    CheckoutTextField(
                      controller: _phoneController,
                      label: 'Téléphone (optionnel)',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CheckoutNavigationButtons(
              onBack: () => _previousStep(),
              onNext: () {
                if (_shippingFormKey.currentState?.validate() == true) {
                  _nextStep();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStep(CartViewModel cartViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _billingFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations de paiement',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[600]),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Mode démo: Paiement simulé',
                                  style: TextStyle(
                                    color: Color(0xFF2C3E50),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Cartes de test valides:\n• 4000 0000 0000 0002 (Visa France)\n• 4242 4242 4242 4242 (Test générique)\n• 5555 5555 5555 4444 (Mastercard)',
                            style: TextStyle(
                              color: Color(0xFF2C3E50),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CheckoutTextField(
                      controller: _cardNameController,
                      label: 'Nom sur la carte',
                      icon: Icons.credit_card,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 16),
                    CheckoutTextField(
                      controller: _cardNumberController,
                      label: 'Numéro de carte',
                      icon: Icons.credit_card_outlined,
                      keyboardType: TextInputType.number,
                      hintText: '4000 0000 0000 0002 (Carte française de test)',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberInputFormatter(),
                      ],
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Ce champ est requis';
                        }
                        final cleanNumber =
                            value!.replaceAll(RegExp(r'\s'), '');
                        if (cleanNumber.length < 13 ||
                            cleanNumber.length > 19) {
                          return 'Numéro de carte invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CheckoutTextField(
                            controller: _cardExpiryController,
                            label: 'Expiration (MM/AA)',
                            icon: Icons.calendar_month,
                            keyboardType: TextInputType.number,
                            hintText: '12/28',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              ExpiryDateInputFormatter(),
                            ],
                            validator: (value) {
                              if (value?.isEmpty == true) return 'Requis';
                              if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value!)) {
                                return 'Format: MM/AA';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CheckoutTextField(
                            controller: _cardCvvController,
                            label: 'CVV',
                            icon: Icons.lock,
                            keyboardType: TextInputType.number,
                            hintText: '123',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (value) {
                              if (value?.isEmpty == true) return 'Requis';
                              if (value!.length < 3 || value.length > 4) {
                                return 'CVV invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CheckoutTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Ce champ est requis';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CheckoutTextField(
                      controller: _billingPhoneController,
                      label: 'Téléphone (optionnel)',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total à payer:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                cartViewModel.formattedTotal,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667EEA),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CheckoutNavigationButtons(
              onBack: () => _previousStep(),
              onNext: () {
                if (_billingFormKey.currentState?.validate() == true) {
                  _processPayment(cartViewModel);
                }
              },
              nextLabel: 'Procéder au paiement',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Consumer<CheckoutViewModel>(
      builder: (context, checkoutViewModel, child) {
        if (checkoutViewModel.isProcessing) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                  strokeWidth: 3,
                ),
                SizedBox(height: 24),
                Text(
                  'Traitement du paiement...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C757D),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Veuillez patienter',
                  style: TextStyle(
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          );
        }

        if (checkoutViewModel.errorMessage != null) {
          return _buildErrorStep(checkoutViewModel.errorMessage!);
        }

        if (checkoutViewModel.completedOrder != null) {
          return _buildSuccessStep(checkoutViewModel.completedOrder!);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorStep(String error) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Erreur de paiement',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6C757D),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _previousStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'RÉESSAYER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessStep(Order order) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Commande confirmée !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Numéro de commande: ${order.id.substring(0, 8).toUpperCase()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Récapitulatif:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${order.items.length} article(s)'),
                    Text('Total: ${order.formattedTotal}'),
                    Text('Status: ${order.statusText}'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/orders'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF667EEA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: const Color(0xFF667EEA)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Mes commandes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667EEA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        'Retour à l\'accueil',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _processPayment(CartViewModel cartViewModel) async {
    final checkoutViewModel =
        Provider.of<CheckoutViewModel>(context, listen: false);

    final shippingAddress = ShippingAddress(
      fullName: _fullNameController.text,
      street: _streetController.text,
      city: _cityController.text,
      postalCode: _postalCodeController.text,
      country: _countryController.text,
      phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
    );

    final billingDetails = BillingDetails(
      name: _cardNameController.text,
      email: _emailController.text,
      phone: _billingPhoneController.text.isNotEmpty
          ? _billingPhoneController.text
          : null,
    );

    _nextStep();

    final success = await checkoutViewModel.processCheckout(
      cartItems: cartViewModel.cartItems,
      shippingAddress: shippingAddress,
      billingDetails: billingDetails,
      cardNumber: _cardNumberController.text,
      onClearCart: () async => await cartViewModel.clearCart(),
    );

    if (!success) {
      return;
    }
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length > 23) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (text[i] != ' ') {
        if (buffer.length > 0 && buffer.length % 4 == 0) {
          buffer.write(' ');
        }
        buffer.write(text[i]);
      }
    }

    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }

    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
