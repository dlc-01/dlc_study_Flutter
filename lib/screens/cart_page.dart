import 'package:flutter/material.dart';
import '../models/crypto.dart';

class CartPage extends StatelessWidget {
  final Map<Crypto, double> cart;
  final Function(Crypto) onRemoveFromCart;
  final double totalPrice;

  const CartPage({
    Key? key,
    required this.cart,
    required this.onRemoveFromCart,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: cart.isEmpty
              ? const Center(child: Text('Корзина пуста'))
              : ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final crypto = cart.keys.elementAt(index);
              final amount = cart[crypto]!;
              return ListTile(
                leading: Image.network(crypto.imageUrl, width: 40),
                title: Text(crypto.name),
                subtitle: Text(
                    'Количество: ${amount.toStringAsFixed(8)} (${(amount * crypto.price).toStringAsFixed(2)} \$)'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => onRemoveFromCart(crypto),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Итоговая стоимость: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const Text(
                  'Сделать заказ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}