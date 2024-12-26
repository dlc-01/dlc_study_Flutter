import 'package:flutter/material.dart';
import 'account_page.dart';
import 'crypto_list_page.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';
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
  Map<Crypto, double> _cart = {};
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
                final input = amountController.text.trim();
                final amount = double.tryParse(input);

                if (amount != null && amount > 0 && _isValidDecimalPlaces(input, 8)) {
                  setState(() {
                    _cart[crypto] = amount;
                  });
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Введите корректное количество до 8 знаков после запятой'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }


  bool _isValidDecimalPlaces(String input, int maxDecimalPlaces) {
    if (input.contains('.')) {
      final parts = input.split('.');
      return parts[1].length <= maxDecimalPlaces;
    }
    return true;
  }
  void _toggleCart(Crypto crypto) {
    setState(() {
      if (_cart.containsKey(crypto)) {
        _cart.remove(crypto);
        crypto.isInCart = false;
      } else {
        _cart[crypto] = 1.0;
        crypto.isInCart = true;
        _showAddToCartDialog(crypto);
      }
    });
  }

  void _removeFromCart(Crypto crypto) {
    setState(() {
      _cart.remove(crypto);
      crypto.isInCart = false;
    });
  }

  double _calculateTotalPrice() {
    return _cart.entries
        .map((entry) => entry.key.price * entry.value)
        .fold(0.0, (sum, current) => sum + current);
  }

  void _deleteCrypto(Crypto crypto) {
    setState(() {
      _cryptoList.removeWhere((item) => item.id == crypto.id);
      _favoriteList.removeWhere((item) => item.id == crypto.id);
      _cart.remove(crypto);
      _cryptoService.deleteCrypto(crypto.symbol);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${crypto.name} удалена')),
    );
  }
  void _updateQuantity(Crypto crypto, double newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _cart.remove(crypto);
        crypto.isInCart = false;
      } else {
        _cart[crypto] = newQuantity;
      }
    });
  }
  void _updateCryptoInList(Crypto updatedCrypto) {
    setState(() {
      final index = _cryptoList.indexWhere((crypto) => crypto.id == updatedCrypto.id);
      if (index != -1) {
        _cryptoList[index] = updatedCrypto;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CryptoListPage(
        cryptoList: _cryptoList,
        isLoading: _isLoading,
        onToggleFavorite: _toggleFavorite,
        onToggleCart: _toggleCart,
        onDeleteCrypto: _deleteCrypto,
        onUpdateCrypto: _updateCryptoInList,
      ),
      FavoritesPage(
        favoriteList: _favoriteList,
        onToggleFavorite: _toggleFavorite,
        onToggleCart: _toggleCart,
      ),
      CartPage(
        cart: _cart,
        onRemoveFromCart: _removeFromCart,
        totalPrice: _calculateTotalPrice(),
        onUpdateQuantity: _updateQuantity,
      ),
      AccountPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0  ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCryptoPage(onAddCrypto: (crypto) {
                setState(() {
                  _cryptoList.add(crypto);
                });
              }),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
      : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Криптовалюты'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Аккаунт'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
      ),
    );
  }
}