import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../providers/service_provider.dart';
import '../screens/create_company_screen.dart';
import '../screens/create_service_screen.dart';

class CompanyListScreen extends StatefulWidget {
  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    final companyProvider = context.read<CompanyProvider>();
    final serviceProvider = context.read<ServiceProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var c in companyProvider.companies) {
        serviceProvider.fetchServicesByCompany(c.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();
    final serviceProvider = context.watch<ServiceProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Companies')),
      body: companyProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : companyProvider.error != null
          ? Center(child: Text(companyProvider.error!))
          : ListView(
              children: companyProvider.companies.map((c) {
                final companyServices = serviceProvider.services
                    .where((s) => s.companyId == c.id)
                    .toList();

                return ExpansionTile(
                  title: Text('${c.name} — ${c.registrationNumber}'),
                  children: [
                    // Show company info
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Company ID: ${c.id}'),
                          Text('Name: ${c.name}'),
                          Text('Registration No: ${c.registrationNumber}'),
                          SizedBox(height: 8),
                          Text(
                            'Services:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Show services
                    if (companyServices.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No services available.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    else
                      ...companyServices.map(
                        (s) => ListTile(
                          title: Text(s.name),
                          subtitle: Text(
                            'RM ${s.price} — ${s.description ?? "No description"}',
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'create_company',
            child: Icon(Icons.add_business),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateCompanyScreen()),
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'create_service',
            child: Icon(Icons.add_task),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateServiceScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
