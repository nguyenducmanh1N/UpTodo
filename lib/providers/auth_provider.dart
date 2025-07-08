import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uptodo/constants/shared_preferences.dart';
import 'package:uptodo/models/user/user_dto.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.loading;
  UserDTO? _currentUser;

  AuthStatus get authStatus => _authStatus;
  UserDTO? get currentUser => _currentUser;

  static const String _authStatusKey = SharedPreferencesKeys.authStatusKey;
  static const String _userDataKey = SharedPreferencesKeys.userDataKey;

  Future<void> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAuthStatus = prefs.getString(_authStatusKey);
      final savedUserData = prefs.getString(_userDataKey);

      if (savedAuthStatus == AuthStatus.authenticated.toString() && savedUserData != null) {
        _currentUser = UserDTO.fromJson(json.decode(savedUserData));
        _authStatus = AuthStatus.authenticated;
      } else {
        _authStatus = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _authStatus = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(UserDTO userData) async {
    _currentUser = userData;
    _authStatus = AuthStatus.authenticated;
    await _saveAuthState();
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _authStatus = AuthStatus.unauthenticated;
    await _clearAuthState();
    notifyListeners();
  }

  Future<void> _saveAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authStatusKey, AuthStatus.authenticated.toString());
    if (_currentUser != null) {
      await prefs.setString(_userDataKey, json.encode(_currentUser!.toJson()));
    }
  }

  Future<void> _clearAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authStatusKey);
    await prefs.remove(_userDataKey);
  }
}
