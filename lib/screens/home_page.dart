import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';
import '../widgets/crypto_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CryptoService _cryptoService = CryptoService();
  List<Crypto> _cryptoList = [];
  List<Crypto> _favoriteList = [];
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildCryptoListPage(),
      _buildFavoritesPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
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
          );
        },
      ),
    );
  }
}