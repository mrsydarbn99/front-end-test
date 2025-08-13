import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/company_provider.dart';
import 'providers/service_provider.dart';
import 'screens/company_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CompanyProvider()..fetchCompanies(),
        ),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vista Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CompanyListScreen(),
    );
  }
}
