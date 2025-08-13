import 'package:flutter/material.dart';
import '../api/client.dart';
import '../models/service.dart';
import 'dart:convert';

class ServiceProvider with ChangeNotifier {
  List<Service> _services = [];
  bool isLoading = false;
  String? error;

  List<Service> get services => _services;

  Future<void> fetchServicesByCompany(int companyId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await ApiClient.get('/services?companyId=$companyId');
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        _services = data.map((s) => Service.fromJson(s)).toList();
      } else {
        error = 'Failed to load services';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addService(
    String name,
    String description,
    double price,
    int companyId,
  ) async {
    try {
      final res = await ApiClient.post('/services', {
        'name': name,
        'description': description,
        'price': price,
        'companyId': companyId,
      });
      if (res.statusCode == 201) {
        await fetchServicesByCompany(companyId);
      } else {
        throw Exception('Failed to create service');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
