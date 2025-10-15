import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/validators.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class RegisterOrderModal extends StatefulWidget {
  const RegisterOrderModal({Key? key}) : super(key: key);

  @override
  State<RegisterOrderModal> createState() => _RegisterOrderModalState();
}

class _RegisterOrderModalState extends State<RegisterOrderModal> {
  final _formKey = GlobalKey<FormState>();
  final _orderService = OrderService();

  late final TextEditingController _userController;
  late final TextEditingController _totalController;
  late final TextEditingController _nameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _countryController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipController;
  late final TextEditingController _cardNameController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _expirationController;
  late final TextEditingController _cvvController;

  int? selectedPaymentMethod;
  final List<String> paymentMethods = [
    'PayPal',
    'Tarjeta de Crédito',
    'Google Pay',
    'Apple Pay',
    'Stripe',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController();
    _totalController = TextEditingController();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _countryController = TextEditingController();
    _stateController = TextEditingController();
    _zipController = TextEditingController();
    _cardNameController = TextEditingController();
    _cardNumberController = TextEditingController();
    _expirationController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _userController.dispose();
    _totalController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expirationController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width < 800 ? double.infinity : 600.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Registrar Orden de Compra',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Usuario / Total
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _userController,
                            hint: 'Usuario',
                            icon: Icons.person,
                            validator: (v) =>
                                validateRequired(v ?? '') ? null : 'Campo requerido',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _totalController,
                            hint: 'Total',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) =>
                                validateNumbers(v ?? '') ? null : 'Solo números',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Nombre / Apellido
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _nameController,
                            hint: 'Nombre',
                            icon: Icons.person_outline,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                            ],
                            validator: (v) =>
                                validateLetters(v ?? '') ? null : 'Solo letras',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _lastNameController,
                            hint: 'Apellido',
                            icon: Icons.person_outline,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                            ],
                            validator: (v) =>
                                validateLetters(v ?? '') ? null : 'Solo letras',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Email / Dirección
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                validateEmail(v ?? '') ? null : 'Email inválido',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _addressController,
                            hint: 'Dirección',
                            icon: Icons.home,
                            validator: (v) =>
                                validateRequired(v ?? '') ? null : 'Campo requerido',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // País / Estado
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _countryController,
                            hint: 'País',
                            icon: Icons.public,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                            ],
                            validator: (v) =>
                                validateLetters(v ?? '') ? null : 'Solo letras',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _stateController,
                            hint: 'Estado',
                            icon: Icons.map,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                            ],
                            validator: (v) =>
                                validateLetters(v ?? '') ? null : 'Solo letras',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Código Postal / Método de Pago
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _zipController,
                            hint: 'Código Postal',
                            icon: Icons.location_on,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            validator: (v) {
                              final s = v ?? '';
                              return (validateNumbers(s) && (s.length == 5 || s.length == 6))
                                  ? null
                                  : '5 o 6 dígitos';
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPaymentDropdown()),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Nombre Tarjeta / Número Tarjeta
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _cardNameController,
                            hint: 'Nombre Tarjeta',
                            icon: Icons.credit_card,
                            validator: (v) =>
                                validateRequired(v ?? '') ? null : 'Campo requerido',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _cardNumberController,
                            hint: 'Número Tarjeta',
                            icon: Icons.credit_card,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                            ],
                            validator: (v) =>
                                validateCardNumber(v ?? '') ? null : '16 dígitos',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Expiración / CVV
                    Row(
                      children: [
                        Expanded(child: _buildExpirationField()),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _cvvController,
                            hint: 'CVV',
                            icon: Icons.lock,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (v) => validateCVV(v ?? '') ? null : '3 dígitos',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0D3B11)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Color(0xFF0D3B11), fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D3B11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                )
                              : const Text(
                                  'Registrar',
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF0D3B11)),
        filled: true,
        fillColor: Colors.green[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
      onChanged: (value) {
        if (textCapitalization == TextCapitalization.words && value.isNotEmpty) {
          final firstLetter = value[0].toUpperCase();
          final rest = value.substring(1);
          if (controller.text != '$firstLetter$rest') {
            controller.value = TextEditingValue(
              text: '$firstLetter$rest',
              selection: TextSelection.collapsed(offset: controller.text.length),
            );
          }
        }
      },
    );
  }

  Widget _buildPaymentDropdown() {
    return DropdownButtonFormField<int>(
      value: selectedPaymentMethod,
      hint: const Text('Método de Pago'),
      items: paymentMethods
          .asMap()
          .entries
          .map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: (val) {
        setState(() => selectedPaymentMethod = val);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green[50],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      validator: (val) => val == null ? 'Selecciona un método' : null,
    );
  }

  Widget _buildExpirationField() {
    return TextFormField(
      controller: _expirationController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Expiración (MM/yy)',
        prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF0D3B11)),
        filled: true,
        fillColor: Colors.green[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => validateExpiration(v ?? '') ? null : 'Fecha inválida',
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
          helpText: 'Selecciona mes/año de expiración',
        );
        if (picked != null) {
          _expirationController.text = DateFormat('MM/yy').format(picked);
          setState(() {});
        }
      },
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final order = Order(
       id: _userController.hashCode,
      userName: _userController.text,
      totalPrice: double.tryParse(_totalController.text) ?? 0,
      firstName: _nameController.text,
      lastName: _lastNameController.text,
      emailAddress: _emailController.text,
      addressLine: _addressController.text,
      country: _countryController.text,
      state: _stateController.text,
      zipCode: _zipController.text,
      cardName: _cardNameController.text,
      cardNumber: _cardNumberController.text,
      expiration: _expirationController.text,
      cvv: _cvvController.text,
      paymentMethod: selectedPaymentMethod ?? 0,
    );

    print("Intentando crear orden: ${order.toJson()}");

    final success = await _orderService.createOrder(order);
    setState(() => _isLoading = false);

    // Notificación flotante tipo Overlay
    _showNotification(success, success ? 'Orden creada exitosamente' : 'Error creando la orden');

    if (success) Navigator.of(context).pop();
  }

  void _showNotification(bool success, String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 40,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: success ? Colors.green[700] : Colors.red[700],
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () => entry.remove());
  }
}
