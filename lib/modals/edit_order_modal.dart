import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class EditOrderModal extends StatefulWidget {
  final Order order;
  final Function(Order) onUpdated;

  const EditOrderModal({super.key, required this.order, required this.onUpdated});

  @override
  State<EditOrderModal> createState() => _EditOrderModalState();
}

class _EditOrderModalState extends State<EditOrderModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userController,
      _totalController,
      _nameController,
      _lastNameController,
      _emailController,
      _addressController,
      _countryController,
      _stateController,
      _zipController,
      _cardNameController,
      _cardNumberController,
      _expirationController,
      _cvvController;

  int? selectedPaymentMethod;
  bool _isLoading = false;

  final List<String> paymentMethods = [
    'PayPal',
    'Tarjeta de Crédito',
    'Google Pay',
    'Apple Pay',
    'Stripe',
  ];

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController(text: widget.order.userName);
    _totalController = TextEditingController(text: widget.order.totalPrice.toString());
    _nameController = TextEditingController(text: widget.order.firstName);
    _lastNameController = TextEditingController(text: widget.order.lastName);
    _emailController = TextEditingController(text: widget.order.emailAddress);
    _addressController = TextEditingController(text: widget.order.addressLine);
    _countryController = TextEditingController(text: widget.order.country);
    _stateController = TextEditingController(text: widget.order.state);
    _zipController = TextEditingController(text: widget.order.zipCode);
    _cardNameController = TextEditingController(text: widget.order.cardName);
    _cardNumberController = TextEditingController(text: widget.order.cardNumber);
    _expirationController = TextEditingController(text: widget.order.expiration);
    _cvvController = TextEditingController(text: widget.order.cvv);
    selectedPaymentMethod = widget.order.paymentMethod;
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

  Future<void> _updateOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedOrder = Order(
        id: widget.order.id, // ✅ ID original
        userName: _userController.text.trim(),
        totalPrice: double.tryParse(_totalController.text) ?? 0,
        firstName: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        emailAddress: _emailController.text.trim(),
        addressLine: _addressController.text.trim(),
        country: _countryController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipController.text.trim(),
        cardName: _cardNameController.text.trim(),
        cardNumber: _cardNumberController.text.trim(),
        expiration: _expirationController.text.trim(),
        cvv: _cvvController.text.trim(),
        paymentMethod: selectedPaymentMethod ?? 0,
      );

      // 🔹 Log del cuerpo que se enviará al backend
      print('🚀 Enviando orden actualizada al backend:');
      print('ID: ${updatedOrder.id}');
      print('Usuario: ${updatedOrder.userName}');
      print('Total: ${updatedOrder.totalPrice}');
      print('Nombre: ${updatedOrder.firstName}');
      print('Apellido: ${updatedOrder.lastName}');
      print('Email: ${updatedOrder.emailAddress}');
      print('Dirección: ${updatedOrder.addressLine}');
      print('País: ${updatedOrder.country}');
      print('Estado: ${updatedOrder.state}');
      print('Código Postal: ${updatedOrder.zipCode}');
      print('Método de Pago: ${updatedOrder.paymentMethod}');
      print('Nombre Tarjeta: ${updatedOrder.cardName}');
      print('Número Tarjeta: ${updatedOrder.cardNumber}');
      print('Expiración: ${updatedOrder.expiration}');
      print('CVV: ${updatedOrder.cvv}');

      final success =
          await OrderService().updateOrder(widget.order.userName, updatedOrder);

      if (success) {
        widget.onUpdated(updatedOrder);
        _showNotification(true);
        Navigator.of(context).pop();
      } else {
        _showNotification(false);
      }
    } catch (e) {
      print('❌ Error al actualizar la orden: $e');
      _showNotification(false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showNotification(bool success) {
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
                  success ? 'Orden actualizada exitosamente' : 'Error al actualizar',
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Editar Orden',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFormFields(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : _updateOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D3B11),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 3),
                                )
                              : const Text(
                                  'Actualizar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
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

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildRow(_userController, 'Usuario', _totalController, 'Total', true),
        _buildRow(_nameController, 'Nombre', _lastNameController, 'Apellido'),
        _buildRow(_emailController, 'Email', _addressController, 'Dirección'),
        _buildRow(_countryController, 'País', _stateController, 'Estado'),
        _buildRow(_zipController, 'Código Postal', null, null, false),
        _buildRow(_cardNameController, 'Nombre Tarjeta', _cardNumberController, 'Número Tarjeta'),
        _buildRow(_expirationController, 'Expiración', _cvvController, 'CVV'),
      ],
    );
  }

  Widget _buildRow(TextEditingController c1, String l1,
      [TextEditingController? c2, String? l2, bool numeric = false, bool withPayment = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(c1, l1, keyboardType: numeric ? TextInputType.number : TextInputType.text),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: withPayment
                ? _buildPaymentDropdown()
                : (c2 != null ? _buildTextField(c2, l2 ?? '') : const SizedBox()),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.green[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
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
      onChanged: (val) => setState(() => selectedPaymentMethod = val),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      validator: (v) => v == null ? 'Selecciona un método' : null,
    );
  }
}
