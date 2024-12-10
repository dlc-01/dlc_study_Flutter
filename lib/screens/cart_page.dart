import 'package:flutter/material.dart';
import '../models/crypto.dart';

class CartPage extends StatelessWidget {
  final Map<Crypto, double> cart;
  final Function(Crypto) onRemoveFromCart;
  final Function(Crypto, double) onUpdateQuantity; // Новый коллбэк для изменения количества
  final double totalPrice;

  const CartPage({
    Key? key,
    required this.cart,
    required this.onRemoveFromCart,
    required this.onUpdateQuantity,
    required this.totalPrice,
  }) : super(key: key);

  void _showEditDialog(BuildContext context, Crypto crypto, double currentAmount) {
    final TextEditingController controller = TextEditingController(
      text: currentAmount.toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Изменить количество для ${crypto.name}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Количество',
              hintText: 'Введите новое количество',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final value = controller.text.trim();
                final parsedAmount = double.tryParse(value);

                if (parsedAmount != null && parsedAmount > 0) {
                  // Округляем до 8 знаков после запятой перед сохранением
                  final sanitizedAmount = double.parse(
                      parsedAmount.toStringAsFixed(8));
                  onUpdateQuantity(crypto, sanitizedAmount);
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Введите корректное количество'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

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
                leading: Image.network(
                  crypto.imageUrl,
                  width: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                      size: 40,
                      color: Colors.red,
                    );
                  },
                ),
                title: Text(crypto.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Цена: \$${crypto.price.toStringAsFixed(2)}',
                    ),
                    Text(
                      'Количество: ${amount.toStringAsFixed(8)}',
                    ),
                    Text(
                      'Общая стоимость: \$${(amount * crypto.price).toStringAsFixed(2)}',
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, crypto, amount);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => onRemoveFromCart(crypto),
                    ),
                  ],
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
                onPressed: () {
                  if (cart.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Корзина пуста, покупка невозможна'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  for (var crypto in cart.keys) {
                    crypto.isInCart = false;
                  }
                  cart.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Покупка совершена!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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