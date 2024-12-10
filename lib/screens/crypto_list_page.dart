import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../widgets/crypto_card.dart';

class CryptoListPage extends StatelessWidget {
  final List<Crypto> cryptoList;
  final bool isLoading;
  final Function(Crypto) onToggleFavorite;
  final Function(Crypto) onToggleCart;

  const CryptoListPage({
    Key? key,
    required this.cryptoList,
    required this.isLoading,
    required this.onToggleFavorite,
    required this.onToggleCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: cryptoList.length,
        itemBuilder: (context, index) {
          return CryptoCard(
            crypto: cryptoList[index],
            onToggleFavorite: () => onToggleFavorite(cryptoList[index]),
            onToggleCart: () => onToggleCart(cryptoList[index]),
          );
        },
      ),
    );
  }
}