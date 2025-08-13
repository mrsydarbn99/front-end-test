import 'service.dart';

class Company {
  final int id;
  final String name;
  final String registrationNumber;
  final List<Service> services;

  Company({
    required this.id,
    required this.name,
    required this.registrationNumber,
    this.services = const [],
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      registrationNumber: json['registrationNumber'],
      services: json['services'] != null
          ? (json['services'] as List).map((s) => Service.fromJson(s)).toList()
          : [],
    );
  }
}
