import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../providers/service_provider.dart';
import 'create_company_screen.dart';
import 'create_service_screen.dart';
import 'package:logger/logger.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  late Logger logger;

  @override
  void initState() {
    super.initState();
    logger = Logger();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companyProvider = context.read<CompanyProvider>();
      final serviceProvider = context.read<ServiceProvider>();

      logger.i("Companies loaded: ${companyProvider.companies.length}");

      for (var c in companyProvider.companies) {
        logger.i("Fetching services for company ${c.name} (ID: ${c.id})");
        serviceProvider.fetchServicesByCompany(c.id).then((_) {
          logger.i("Fetched services for company ${c.id}");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();
    final serviceProvider = context.watch<ServiceProvider>();

    if (companyProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (companyProvider.error != null) {
      return Scaffold(body: Center(child: Text(companyProvider.error!)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Companies')),
      body: ListView(
        children: companyProvider.companies.map((c) {
          // Try getting services from provider
          var companyServices = serviceProvider.services
              .where((s) => s.companyId == c.id)
              .toList();

          // If none in provider, try from company object (API embedded)
          if (companyServices.isEmpty && c.services != null) {
            companyServices = c.services!;
          }

          // logger.i(
          //   "Company: ${c.name} (${c.id}) has ${companyServices.length} services",
          // );
          // for (var s in companyServices) {
          //   logger.d(
          //     "Service: ${s.name} | Price: RM ${s.price} | Desc: ${s.description ?? 'No description'}",
          //   );
          // }

          return ExpansionTile(
            title: Text('${c.name} — ${c.registrationNumber}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company ID: ${c.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Name: ${c.name}'),
                    Text('Registration No: ${c.registrationNumber}'),
                    const SizedBox(height: 8),
                    const Text(
                      'Services:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (companyServices.isEmpty)
                      Text(
                        'No services available.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      )
                    else
                      ...companyServices.map(
                        (s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  s.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'RM ${s.price} — ${s.description ?? "No description"}',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
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
            child: const Icon(Icons.add_business),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateCompanyScreen()),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'create_service',
            child: const Icon(Icons.add_task),
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
