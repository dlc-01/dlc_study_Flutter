import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';
import '../widgets/crypto_card.dart';
import 'add_crypto_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CryptoService _cryptoService = CryptoService();
  List<Crypto> _cryptoList = [];
  List<Crypto> _favoriteList = [];
  Map<Crypto, double> _cart = {}; // Хранение криптовалют и их количества
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCryptoData();
  }

  Future<void> _loadCryptoData() async {
    try {
      final data = await _cryptoService.fetchCryptoData();
      setState(() {
        _cryptoList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading crypto data: $e');
    }
  }

  void _toggleFavorite(Crypto crypto) {
    setState(() {
      crypto.isFavorite = !crypto.isFavorite;
      if (crypto.isFavorite) {
        _favoriteList.add(crypto);
      } else {
        _favoriteList.removeWhere((item) => item.id == crypto.id);
      }
    });
  }

  void _toggleCart(Crypto crypto) {
    setState(() {
      if (_cart.containsKey(crypto)) {
        _cart.remove(crypto);
        crypto.isInCart = false;
      } else {
        _cart[crypto] = 1.0; // Добавляем в корзину с дефолтным количеством
        crypto.isInCart = true;
        _showAddToCartDialog(crypto);
      }
    });
  }

  void _showAddToCartDialog(Crypto crypto) {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Добавить ${crypto.name} в корзину'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Количество',
              hintText: 'Введите количество (до 8 знаков после запятой)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  setState(() {
                    _cart[crypto] = amount;
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _addNewCrypto(Crypto crypto) {
    setState(() {
      _cryptoList.add(crypto);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double _calculateTotalPrice() {
    return _cart.entries
        .map((entry) => entry.key.price * entry.value)
        .fold(0.0, (sum, current) => sum + current);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildCryptoListPage(),
      _buildFavoritesPage(),
      _buildCartPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCryptoPage(onAddCrypto: _addNewCrypto),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Криптовалюты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCryptoListPage() {
    return _isLoading
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
        itemCount: _cryptoList.length,
        itemBuilder: (context, index) {
          return CryptoCard(
            crypto: _cryptoList[index],
            onToggleFavorite: () => _toggleFavorite(_cryptoList[index]),
            onToggleCart: () => _toggleCart(_cryptoList[index]),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return _favoriteList.isEmpty
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
        itemCount: _favoriteList.length,
        itemBuilder: (context, index) {
          return CryptoCard(
            crypto: _favoriteList[index],
            onToggleFavorite: () => _toggleFavorite(_favoriteList[index]),
            onToggleCart: () => _toggleCart(_favoriteList[index]),
          );
        },
      ),
    );
  }

  Widget _buildCartPage() {
    return Column(
      children: [
        Expanded(
          child: _cart.isEmpty
              ? const Center(child: Text('Корзина пуста'))
              : ListView.builder(
            itemCount: _cart.length,
            itemBuilder: (context, index) {
              final crypto = _cart.keys.elementAt(index);
              final amount = _cart[crypto]!;
              return ListTile(
                leading: Image.network(crypto.imageUrl, width: 40),
                title: Text(crypto.name),
                subtitle: Text(
                    'Количество: ${amount.toStringAsFixed(8)} (${(amount * crypto.price).toStringAsFixed(2)} \$)'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      _cart.remove(crypto);
                      crypto.isInCart = false;
                    });
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Итоговая стоимость: \$${_calculateTotalPrice().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}