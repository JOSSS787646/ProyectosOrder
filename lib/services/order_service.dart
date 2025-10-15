import 'dart:convert';
import '../models/order.dart';
import '../utils/api_helper.dart';

class OrderService {


  //REGISTARUNA ORDEN
  Future<bool> createOrder(Order order) async {
    final response = await ApiHelper.post('Order', order.toJson());
    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      return true;
    } else {
      print("Error creando orden: ${response?.body}");
      return false;
    }
  }


  /// Nuevo método: buscar orden por usuario
  Future<List<Order>> getOrdersByUser(String userName) async {
    final response = await ApiHelper.get('Order/$userName');

    if (response != null && response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Datos recibidos para $userName: $data");

      return data.map((json) => Order(
          id: json["id"],
            userName: json['userName'] ?? '',
            totalPrice: (json['totalPrice'] ?? 0).toDouble(),
            firstName: json['firstName'] ?? '',
            lastName: json['lastName'] ?? '',
            emailAddress: json['emailAddress'] ?? '',
            addressLine: json['addressLine'] ?? '',
            country: json['country'] ?? '',
            state: json['state'] ?? '',
            zipCode: json['zipCode'] ?? '',
            cardName: json['cardName'] ?? '',
            cardNumber: json['cardNumber'] ?? '',
            expiration: json['expiration'] ?? '',
            cvv: json['cvv'] ?? '',
            paymentMethod: json['payMentMethod'] ?? 0,
          ))
          .toList();
    } else {
      print("Error buscando orden de $userName: ${response?.body}");
      return [];
    }
  }

    /// 🔍 Nuevo método: Buscar una orden por su ID
  Future<Order?> getOrderById(int id) async {
    final response = await ApiHelper.get('Order/byId/$id');

    if (response != null && response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Orden encontrada (ID $id): $json");

      return Order(
        id: json["id"],
        userName: json['userName'] ?? '',
        totalPrice: (json['totalPrice'] ?? 0).toDouble(),
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        emailAddress: json['emailAddress'] ?? '',
        addressLine: json['addressLine'] ?? '',
        country: json['country'] ?? '',
        state: json['state'] ?? '',
        zipCode: json['zipCode'] ?? '',
        cardName: json['cardName'] ?? '',
        cardNumber: json['cardNumber'] ?? '',
        expiration: json['expiration'] ?? '',
        cvv: json['cvv'] ?? '',
        paymentMethod: json['payMentMethod'] ?? 0,
      );
    } else {
      print("Error obteniendo orden con ID $id: ${response?.body}");
      return null;
    }
  }


   Future<bool> updateOrder(String userName, Order order) async {
    final response = await ApiHelper.put('Order', order.toJson());
    if (response != null && (response.statusCode == 200 || response.statusCode == 204)) {
      return true;
    }
    print("Error actualizando orden: ${response?.body}");
    return false;
  }

   /// 🔥 Nuevo método: Eliminar orden por ID
  Future<bool> deleteOrder(int id) async {
    final response = await ApiHelper.delete('Order/$id');
    if (response != null && (response.statusCode == 200 || response.statusCode == 204)) {
      print("Orden eliminada correctamente (ID $id)");
      return true;
    } else {
      print("Error eliminando orden con ID $id: ${response?.body}");
      return false;
    }
  }

  
}
