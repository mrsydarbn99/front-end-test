import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import '../providers/company_provider.dart';

class CreateServiceScreen extends StatefulWidget {
  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  int? selectedCompanyId;

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Create Service')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Service Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || double.tryParse(val) == null
                    ? 'Enter valid price'
                    : null,
              ),
              DropdownButtonFormField<int>(
                value: selectedCompanyId,
                items: companyProvider.companies
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedCompanyId = val),
                decoration: InputDecoration(labelText: 'Select Company'),
                validator: (val) => val == null ? 'Select a company' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await serviceProvider.addService(
                      nameController.text,
                      descController.text,
                      double.parse(priceController.text),
                      selectedCompanyId!,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
