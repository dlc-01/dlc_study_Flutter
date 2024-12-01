import 'package:flutter/material.dart';
import '../models/crypto.dart';

class CryptoCard extends StatelessWidget {
  final Crypto crypto;

  const CryptoCard({Key? key, required this.crypto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(crypto.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Symbol: ${crypto.symbol}'),
                      Text('Current Price: \$${crypto.price.toStringAsFixed(10)}'),
                      Text(
                        'Market Cap: \$${crypto.marketCap.toStringAsFixed(2)}',
                      ),
                      Text(
                        '24h Change: ${crypto.priceChange24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: crypto.priceChange24h >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Details'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}