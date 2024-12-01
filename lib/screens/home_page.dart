import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';
import 'add_crypto_page.dart';
import '../widgets/crypto_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CryptoService _cryptoService = CryptoService();
  List<Crypto> _cryptoList = [];
  bool _isLoading = true;

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

  void _addNewCrypto(Crypto crypto) {
    setState(() {
      _cryptoList.add(crypto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
        centerTitle: true,
      ),
      body: _isLoading
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
            return CryptoCard(crypto: _cryptoList[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddCryptoPage(onAddCrypto: _addNewCrypto),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}