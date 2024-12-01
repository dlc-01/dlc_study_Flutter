class Crypto {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double marketCap;
  final double priceChange24h;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.marketCap,
    required this.priceChange24h,
  });

  factory Crypto.fromJson(Map<String, dynamic> json, String imageUrl) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: imageUrl,
      price: json['current_price']?.toDouble() ?? 0.0,
      marketCap: json['market_cap']?.toDouble() ?? 0.0,
      priceChange24h: json['price_change_percentage_24h']?.toDouble() ?? 0.0,
    );
  }
}