import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/crypto.dart';

class AddCryptoPage extends StatefulWidget {
  final Function(Crypto) onAddCrypto;

  const AddCryptoPage({Key? key, required this.onAddCrypto}) : super(key: key);

  @override
  State<AddCryptoPage> createState() => _AddCryptoPageState();
}

class _AddCryptoPageState extends State<AddCryptoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _symbolController = TextEditingController();
  bool _isLoading = false;

  Future<Crypto?> _fetchCryptoData(String symbol) async {
    final url = 'https://api.coincap.io/v2/assets/$symbol';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          final cryptoData = data['data'];
          return Crypto(
            id: cryptoData['id'],
            name: cryptoData['name'],
            symbol: cryptoData['symbol'],
            imageUrl:
            'https://assets.coincap.io/assets/icons/${cryptoData['symbol'].toLowerCase()}@2x.png',
            price: double.tryParse(cryptoData['priceUsd'] ?? '0.0') ?? 0.0,
            marketCap: double.tryParse(cryptoData['marketCapUsd'] ?? '0.0') ?? 0.0,
            priceChange24h: double.tryParse(cryptoData['changePercent24Hr'] ?? '0.0') ?? 0.0,
          );
        }
      }
    } catch (e) {
      print('Ошибка при получении данных о криптовалюте: $e');
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final symbol = _symbolController.text.trim().toLowerCase();
      final crypto = await _fetchCryptoData(symbol);

      setState(() {
        _isLoading = false;
      });

      if (crypto != null) {
        widget.onAddCrypto(crypto);
        Navigator.pop(context);
      } else {
        _showErrorDialog('Нет такой криптовалюты');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить криптовалюту'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _symbolController,
                decoration: const InputDecoration(labelText: 'Название криптовалюты'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите название криптовалюты' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Добавить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}