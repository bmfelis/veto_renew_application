import 'package:flutter/material.dart';
import 'package:veto_renew_application/pages/welcome_page.dart';

void main() {
  runApp(const vetoApp());
}

class vetoApp extends StatelessWidget {
  const vetoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
