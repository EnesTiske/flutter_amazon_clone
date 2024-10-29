import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double sum = 0;
    user.cart
        .map((e) {
            double quantity = e['quantity'] is int ? (e['quantity'] as int).toDouble() : e['quantity'];
            double price = e['product']['price'] is int ? (e['product']['price'] as int).toDouble() : e['product']['price'];
            sum += quantity * price;
        })
        .toList();
    
    sum = double.parse(sum.toStringAsFixed(2));
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal: ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\$$sum',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}