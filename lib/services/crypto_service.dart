import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto.dart';

class CryptoService {
  final Map<String, String> cryptoImages = {
    'bitcoin': 'https://assets.coincap.io/assets/icons/btc@2x.png',
    'ethereum': 'https://assets.coincap.io/assets/icons/eth@2x.png',
    'cardano': 'https://assets.coincap.io/assets/icons/ada@2x.png',
    'ripple': 'https://assets.coincap.io/assets/icons/xrp@2x.png',
    'solana': 'https://assets.coincap.io/assets/icons/sol@2x.png',
    'binancecoin': 'https://assets.coincap.io/assets/icons/bnb@2x.png',
  };

  Future<List<Crypto>> fetchCryptoData() async {
    final ids = cryptoImages.keys.join(',');
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$ids');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        final id = json['id'];
        final imageUrl = cryptoImages[id] ?? '';
        return Crypto.fromJson(json, imageUrl);
      }).toList();
    } else {
      throw Exception('Failed to load crypto data');
    }
  }
}