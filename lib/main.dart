import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goldinventory/pages/home_screen.dart';
import 'package:goldinventory/pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goldinventory/providers/user_provider.dart';
import 'package:goldinventory/utils/color_scheme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final userProvider = UserProvider();
  await userProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => userProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Inventário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: customColorScheme,
          useMaterial3: true,
          fontFamily: 'Roboto'),
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const Home();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
