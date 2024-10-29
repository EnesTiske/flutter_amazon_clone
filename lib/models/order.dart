import 'dart:convert';

import 'package:amazon_clone_tutorial/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final DateTime orderedAt;
  final int status;

  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((product) => product.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt.toIso8601String(), 
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<Product>.from(map['products']?.map((x) => Product.fromMap(x['product']))),
      quantity: List<int>.from(map['products']?.map((x) => x['quantity'])),
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: DateTime.parse(map['orderedAt']),
      status: map['status'] is String ? int.parse(map['status']) : map['status'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}