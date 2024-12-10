import 'package:flutter/material.dart';
import '../models/crypto.dart';

class CryptoDetailsPage extends StatelessWidget {
  final Crypto crypto;

  const CryptoDetailsPage({Key? key, required this.crypto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crypto.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                crypto.imageUrl,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error,
                    size: 100,
                    color: Colors.red,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${crypto.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Symbol: ${crypto.symbol}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Current Price: \$${crypto.price.toStringAsFixed(10)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Market Cap: \$${crypto.marketCap.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '24h Change: ${crypto.priceChange24h.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 16,
                color: crypto.priceChange24h >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}