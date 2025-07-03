import 'package:flutter/material.dart';
import 'package:uptodo/models/user/user_dto.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.unauthenticated;
  UserDTO? _currentUser;

  AuthStatus get authStatus => _authStatus;
  UserDTO? get currentUser => _currentUser;

  void login(UserDTO user) {
    _authStatus = AuthStatus.authenticated;
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _authStatus = AuthStatus.unauthenticated;
    _currentUser = null;
    notifyListeners();
  }
}
