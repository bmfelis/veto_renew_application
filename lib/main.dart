import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veto_renew_application/pages/registration_page.dart';
import 'package:veto_renew_application/pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:veto_renew_application/provider/auth_provider.dart' as vetoAuthProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VetoApp());
}

class VetoApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  VetoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => vetoAuthProvider.AuthProvider()), 
      ],
      child: MaterialApp(
        title: 'Veto Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: FutureBuilder<User?>(
          future: _initialization.then((value) => FirebaseAuth.instance.authStateChanges().first),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData == true) {
              return const RegistrationPage();
            } else {
              return const WelcomePage();
            }
          },
        ),
      ),
    );
  }
}
