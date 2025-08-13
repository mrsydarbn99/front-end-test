import 'package:flutter/material.dart';
import '../api/client.dart';
import '../models/company.dart';
import 'dart:convert';

class CompanyProvider with ChangeNotifier {
  List<Company> _companies = [];
  bool isLoading = false;
  String? error;

  List<Company> get companies => _companies;

  Future<void> fetchCompanies() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await ApiClient.get('/companies');
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        _companies = data.map((c) => Company.fromJson(c)).toList();
      } else {
        error = 'Failed to load companies';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCompany(String name, String regNo) async {
    try {
      final res = await ApiClient.post('/companies', {
        'name': name,
        'registrationNumber': regNo,
      });
      if (res.statusCode == 201) {
        await fetchCompanies(); // reload list
      } else {
        throw Exception('Failed to create company');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
