import 'package:flutter/material.dart';
import '../modals/register_order_modal.dart';
import  '../pages/login_page.dart'; // Asegúrate de importar tu LoginPage

class SideMenu extends StatefulWidget {
  final bool isMobile;
  const SideMenu({Key? key, this.isMobile = false}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 0, end: 120).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      if (isMenuOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget menuItem(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      hoverColor: const Color(0xFF388E3C),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = widget.isMobile ? double.infinity : 250.0;

    return Container(
      width: sidebarWidth,
      color: const Color(0xFF08270A),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 24, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.white),
              title: const Text('Órdenes de Compra', style: TextStyle(color: Colors.white)),
              trailing: Icon(
                isMenuOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onTap: toggleMenu,
            ),
            SizeTransition(
              sizeFactor: _heightAnimation,
              axisAlignment: -1.0,
              child: Column(
                children: [
                  menuItem('Registrar Orden', Icons.add_box, onTap: () {
                    _showRegisterOrderModal(context);
                  }),
                  menuItem('Ver Órdenes', Icons.list_alt, onTap: () {}),
                  menuItem('Historial', Icons.history, onTap: () {}),
                  menuItem('Reportes', Icons.bar_chart, onTap: () {}),
                ],
              ),
            ),
            const Spacer(),
            const Divider(color: Colors.white54),
            menuItem(
              'Cerrar Sesión',
              Icons.logout,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRegisterOrderModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegisterOrderModal(key: UniqueKey());
      },
    );
  }
}
