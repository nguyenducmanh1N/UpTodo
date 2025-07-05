import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/widgets/home_screen.dart';
import 'widgets/auth/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.authStatus == AuthStatus.authenticated ? HomeScreen() : LoginScreen();
        },
      ),
    );
  }
}
