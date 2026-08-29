import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Central place for all backend calls.
///
/// baseUrl notes (Spring Boot runs on port 8080 by default):
///  - Android emulator:      http://10.0.2.2:8080
///  - iOS simulator:         http://localhost:8080
///  - Physical device:       http://<your-computer-LAN-IP>:8080
///  - Production:            https://your-deployed-api.example.com
class ApiService {
 static const String baseUrl = 'http://192.168.20.6:8080/api';

  // ---------- Farmers ----------
  static Future<Farmer> registerFarmer({
    required String name,
    required String phoneNumber,
    required String location,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/farmers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phoneNumber': phoneNumber,
        'location': location,
      }),
    );
    if (res.statusCode == 200) {
      return Farmer.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to register farmer: ${res.body}');
  }

  // ---------- Products ----------
  static Future<List<Product>> browseCatalog() async {
    final res = await http.get(Uri.parse('$baseUrl/products'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load catalog: ${res.body}');
  }

  static Future<Product> listProduct({
    required String name,
    required double quantityAvailable,
    required double pricePerUnit,
    required int farmerId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'quantityAvailable': quantityAvailable,
        'pricePerUnit': pricePerUnit,
        'farmerId': farmerId,
      }),
    );
    if (res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to list product: ${res.body}');
  }

  // ---------- Orders ----------
  static Future<OrderResult> placeOrder({
    required int productId,
    required String buyerName,
    required String buyerContact,
    required String deliveryAddress,
    required double quantityOrdered,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productId': productId,
        'buyerName': buyerName,
        'buyerContact': buyerContact,
        'deliveryAddress': deliveryAddress,
        'quantityOrdered': quantityOrdered,
      }),
    );
    if (res.statusCode == 200) {
      return OrderResult.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to place order: ${res.body}');
  }

  static Future<List<OrderResult>> ordersForFarmer(int farmerId) async {
    final res = await http.get(Uri.parse('$baseUrl/orders/farmer/$farmerId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => OrderResult.fromJson(e)).toList();
    }
    throw Exception('Failed to load orders: ${res.body}');
  }

  static Future<void> confirmOrder(int orderId) async {
    final res = await http.patch(Uri.parse('$baseUrl/orders/$orderId/confirm'));
    if (res.statusCode != 200) {
      throw Exception('Failed to confirm order: ${res.body}');
    }
  }

  // ---------- Assistance requests ----------
  static Future<void> submitAssistanceRequest({
    required int farmerId,
    required String topic,
    required String description,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/assistance'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'farmerId': farmerId,
        'topic': topic,
        'description': description,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to submit request: ${res.body}');
    }
  }

  static Future<List<AssistanceRequestResult>> requestsForFarmer(int farmerId) async {
    final res = await http.get(Uri.parse('$baseUrl/assistance/farmer/$farmerId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => AssistanceRequestResult.fromJson(e)).toList();
    }
    throw Exception('Failed to load requests: ${res.body}');
  }
}
