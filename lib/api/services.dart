import 'dart:convert';
import 'client.dart';

class Service {
  final int id;
  final String name;
  final double price;
  final int companyId;
  final String? description;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.companyId,
    this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      companyId: json['companyId'],
      description: json['description'],
    );
  }
}

Future<Service> getServiceById(int id) async {
  final res = await ApiClient.get('/services/$id');
  if (res.statusCode == 200) {
    return Service.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to load service');
  }
}

Future<void> createService(
  String name,
  double price,
  int companyId,
  String? desc,
) async {
  final res = await ApiClient.post('/services', {
    'name': name,
    'price': price,
    'companyId': companyId,
    'description': desc,
  });
  if (res.statusCode != 201) {
    throw Exception('Failed to create service');
  }
}
