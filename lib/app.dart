import 'package:flutter/material.dart';
import 'package:qr_code/pages/qr_code_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QRCodeScreen(),
    );
  }
}
