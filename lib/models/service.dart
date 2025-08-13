class Service {
  final int id;
  final String name;
  final double price;
  final int companyId;
  final String description;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.companyId,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      companyId: json['companyId'],
      description: json['description'] ?? '',
    );
  }
}
