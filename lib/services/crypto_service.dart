import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/crypto.dart';

class CryptoService {
  final String baseUrl = 'http://192.168.0.17:8080'; // Укажите ваш API URL

  Future<List<Crypto>> fetchCryptoData() async {
    final url = Uri.parse('$baseUrl/cryptos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        final id = json['id'];
        final imageUrl = json['imageUrl'];
        return Crypto.fromJson(json, imageUrl);
      }).toList();
    } else {
      throw Exception('Failed to load crypto data');
    }
  }

  Future<Crypto> createCrypto(String symbol, String description) async {
    final url = Uri.parse('$baseUrl/crypto');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'symbol': symbol, 'description': description}),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Crypto.fromJson(data, data['imageUrl']);
    } else {
      throw Exception('Failed to create crypto');
    }
  }

  Future<void> updateCrypto(Crypto crypto) async {
    final url = Uri.parse('$baseUrl/cryptos');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': crypto.id,
        'name': crypto.name,
        'symbol': crypto.symbol,
        'imageUrl': crypto.imageUrl,
        'price': crypto.price,
        'marketCap': crypto.marketCap,
        'priceChange24h': crypto.priceChange24h,
        'description': crypto.description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update crypto');
    }
  }

  Future<void> deleteCrypto(String symbol) async {
    final url = Uri.parse('$baseUrl/cryptos/$symbol');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete crypto');
    }
  }
}
