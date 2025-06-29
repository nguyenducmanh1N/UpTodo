import 'package:flutter/material.dart';
import 'package:uptodo/widgets/home_screen.dart';

import 'widgets/auth/login_screen.dart';

enum AuthStatus { authorized, unAuthorized }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthStatus _authStatus = AuthStatus.unAuthorized;

  void _login() {
    setState(() {
      _authStatus = AuthStatus.authorized;
    });
  }

  void _logout() {
    setState(() {
      _authStatus = AuthStatus.unAuthorized;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _authStatus == AuthStatus.authorized ? HomeScreen(onLogout: _logout) : LoginScreen(onLogin: _login),
    );
  }
}
