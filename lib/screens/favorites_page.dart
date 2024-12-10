import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../widgets/crypto_card.dart';

class FavoritesPage extends StatelessWidget {
  final List<Crypto> favoriteList;
  final Function(Crypto) onToggleFavorite;
  final Function(Crypto) onToggleCart;

  const FavoritesPage({
    Key? key,
    required this.favoriteList,
    required this.onToggleFavorite,
    required this.onToggleCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return favoriteList.isEmpty
        ? const Center(child: Text('Нет избранных криптовалют'))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                return CryptoCard(
                  crypto: favoriteList[index],
                  onToggleFavorite: () =>
                      onToggleFavorite(favoriteList[index]),
                  onToggleCart: () => onToggleCart(favoriteList[index]),
                );
              },
            ),
          );
  }
}