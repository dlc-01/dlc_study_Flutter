import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../widgets/crypto_card.dart';

class FavoritesPage extends StatelessWidget {
  final List<Crypto> favoriteCryptos;

  const FavoritesPage({Key? key, required this.favoriteCryptos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        centerTitle: true,
      ),
      body: favoriteCryptos.isEmpty
          ? const Center(
        child: Text('Нет избранных криптовалют'),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: favoriteCryptos.length,
          itemBuilder: (context, index) {
            return CryptoCard(crypto: favoriteCryptos[index], onToggleFavorite: () {  },);
          },
        ),
      ),
    );
  }
}