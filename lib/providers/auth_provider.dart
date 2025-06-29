import 'package:flutter/material.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.unauthenticated;

  AuthStatus get authStatus => _authStatus;

  void login() {
    _authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
