import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchBox({super.key, required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final width = isMobile ? double.infinity : 500.0;

    return Container(
      width: width,
      child: TextField(
        controller: controller,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: 'Buscar por ID de usuario',
          prefixIcon: Icon(Icons.search, color: Color(0xFF0D3B11)),
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: Color(0xFF0D3B11)),
            onPressed: onSearch,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
    );
  }
}
