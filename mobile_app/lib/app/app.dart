import 'package:flutter/material.dart';
import 'package:smartscan/features/document/presentation/document_list_page.dart';

class SmartScanApp extends StatelessWidget {
  const SmartScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const DocumentListPage(),
    );
  }
}
