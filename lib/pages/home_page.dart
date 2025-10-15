import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import '../widgets/search_box.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import '../modals/edit_order_modal.dart';
import '../modals/delete_order_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final OrderService _orderService = OrderService();
  List<Order> _results = [];
  bool _loading = false;
  bool _notFound = false;

  Future<void> _search() async {
    final userName = _searchController.text.trim();
    if (userName.isEmpty) return;

    setState(() {
      _loading = true;
      _notFound = false;
    });

    final orders = await _orderService.getOrdersByUser(userName);

    setState(() {
      _results = orders;
      _loading = false;
      _notFound = orders.isEmpty;
    });
  }

  void _editOrder(Order order) {
    showDialog(
      context: context,
      builder: (context) => EditOrderModal(
        order: order,
        onUpdated: (updatedOrder) {
          setState(() {
            final index =
                _results.indexWhere((o) => o.userName == updatedOrder.userName);
            if (index != -1) _results[index] = updatedOrder;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text('Carrito de Compras'),
              backgroundColor: const Color(0xFF0D3B11),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      drawer: isMobile ? Drawer(child: SideMenu(isMobile: true)) : null,
      body: Row(
        children: [
          if (!isMobile) const SideMenu(isMobile: false),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFDFF0E3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: SearchBox(
                        controller: _searchController,
                        onSearch: _search,
                      ),
                    ),
                  ),
                  _loading
                      ? const Center(
                          child:
                              CircularProgressIndicator(color: Color(0xFF0D3B11)),
                        )
                      : _notFound
                          ? Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'No se encontraron resultados',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : _results.isNotEmpty
                              ? Expanded(child: _buildResultsTable())
                              : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTableHeader(),
              Divider(height: 1, color: Colors.green[200]),
              ..._results.asMap().entries.map((entry) {
                final index = entry.key;
                final order = entry.value;
                final bgColor =
                    index % 2 == 0 ? Colors.green[50] : Colors.white;
                return Container(
                  color: bgColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      _cellActions(order),
                      _cell(order.userName),
                      _cell(order.firstName),
                      _cell(order.lastName),
                      _cell(order.emailAddress),
                      _cell(order.addressLine),
                      _cell(order.country),
                      _cell(order.state),
                      _cell(order.zipCode),
                      _cell(order.cardName),
                      _cell(order.cardNumber),
                      _cell(order.expiration),
                      _cell(order.cvv),
                      _cell(order.paymentMethod.toString()),
                      _cell(order.totalPrice.toStringAsFixed(2)),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    final headers = [
      'Acciones',
      'Usuario',
      'Nombre',
      'Apellido',
      'Email',
      'Dirección',
      'País',
      'Estado',
      'C.P.',
      'Titular',
      'Tarjeta',
      'Expira',
      'CVV',
      'Método',
      'Total',
    ];

    return Container(
      color: Colors.green[100],
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: headers.map((h) => _cell(h, isHeader: true)).toList(),
      ),
    );
  }

  Widget _cell(String text, {bool isHeader = false}) {
    return Container(
      width: 120,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? const Color(0xFF2E7D32) : Colors.black87,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _cellActions(Order order) {
    return SizedBox(
      width: 160,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.edit, size: 18, color: Colors.white),
            label: const Text('Editar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            onPressed: () => _editOrder(order),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete, size: 18, color: Colors.white),
            label: const Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => DeleteOrderModal(
                  order: order,
                  onDeleted: () {
                    setState(() {
                      _results.remove(order); // Solo se elimina si la BD confirma
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
