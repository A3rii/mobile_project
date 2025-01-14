class Court {
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Court({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
