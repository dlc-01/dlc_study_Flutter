import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../widgets/crypto_card.dart';

class CryptoListPage extends StatelessWidget {
  final List<Crypto> cryptoList;
  final bool isLoading;
  final Function(Crypto) onToggleFavorite;
  final Function(Crypto) onToggleCart;
  final Function(Crypto) onDeleteCrypto; // Новый коллбэк для удаления криптовалюты

  const CryptoListPage({
    Key? key,
    required this.cryptoList,
    required this.isLoading,
    required this.onToggleFavorite,
    required this.onToggleCart,
    required this.onDeleteCrypto, // Передаем коллбэк
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Количество элементов в строке
          childAspectRatio: 0.8, // Соотношение сторон (ширина к высоте)
          crossAxisSpacing: 10, // Отступы между элементами по горизонтали
          mainAxisSpacing: 10, // Отступы между элементами по вертикали
        ),
        itemCount: cryptoList.length,
        itemBuilder: (context, index) {
          final crypto = cryptoList[index];

          return Dismissible(
            key: ValueKey(crypto.id),
            direction: DismissDirection.endToStart, // Свайп влево
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              onDeleteCrypto(crypto); // Вызываем коллбэк для удаления
            },
            child: CryptoCard(
              crypto: crypto,
              onToggleFavorite: () => onToggleFavorite(crypto),
              onToggleCart: () => onToggleCart(crypto),
            ),
          );
        },
      ),
    );
  }
}