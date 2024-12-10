import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../screens/crypto_details_page.dart';

class CryptoCard extends StatelessWidget {
  final Crypto crypto;
  final VoidCallback onToggleFavorite;

  const CryptoCard({
    Key? key,
    required this.crypto,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Открытие окна с деталями криптовалюты
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CryptoDetailsPage(crypto: crypto),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              crypto.imageUrl,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  size: 100,
                  color: Colors.red,
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              crypto.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Price: \$${crypto.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: Icon(
                crypto.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: crypto.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}