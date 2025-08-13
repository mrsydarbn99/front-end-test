import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';

class CreateCompanyScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final regController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Create Company')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: regController,
                decoration: InputDecoration(labelText: 'Registration Number'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await companyProvider.addCompany(
                      nameController.text,
                      regController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Company'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
