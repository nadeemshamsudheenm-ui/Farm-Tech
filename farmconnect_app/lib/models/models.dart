class Farmer {
  final int id;
  final String name;
  final String location;

  Farmer({required this.id, required this.name, required this.location});

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}

/// Buyer-facing product listing. Matches backend's ProductCatalogDTO —
/// notice there is no farmer name/phone here, only location + product info.
class Product {
  final int productId;
  final String productName;
  final double quantityAvailable;
  final double pricePerUnit;
  final String farmerLocation;

  Product({
    required this.productId,
    required this.productName,
    required this.quantityAvailable,
    required this.pricePerUnit,
    required this.farmerLocation,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      productName: json['productName'],
      quantityAvailable: (json['quantityAvailable'] as num).toDouble(),
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      farmerLocation: json['farmerLocation'] ?? '',
    );
  }
}

class OrderResult {
  final int orderId;
  final String productName;
  final double quantityOrdered;
  final double totalPrice;
  final String status;

  OrderResult({
    required this.orderId,
    required this.productName,
    required this.quantityOrdered,
    required this.totalPrice,
    required this.status,
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) {
    return OrderResult(
      orderId: json['orderId'],
      productName: json['productName'],
      quantityOrdered: (json['quantityOrdered'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'],
    );
  }
}

class AssistanceRequestResult {
  final int id;
  final String topic;
  final String description;
  final bool resolved;

  AssistanceRequestResult({
    required this.id,
    required this.topic,
    required this.description,
    required this.resolved,
  });

  factory AssistanceRequestResult.fromJson(Map<String, dynamic> json) {
    return AssistanceRequestResult(
      id: json['id'],
      topic: json['topic'],
      description: json['description'],
      resolved: json['resolved'] ?? false,
    );
  }
}
