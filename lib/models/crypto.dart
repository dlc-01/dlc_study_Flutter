class Crypto {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double marketCap;
  final double priceChange24h;
  final String? description;
  bool isFavorite;
  bool isInCart;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.marketCap,
    required this.priceChange24h,
    this.description,
    this.isFavorite = false,
    this.isInCart = false,
  });

  factory Crypto.fromJson(Map<String, dynamic> json, String imageUrl) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: imageUrl,
      price: json['priceUsd']?.toDouble() ?? 0.0,
      marketCap: json['marketCapUsd;']?.toDouble() ?? 0.0,
      priceChange24h: json['changePercent24Hr']?.toDouble() ?? 0.0,
      description: json['description'],
    );
  }
}
