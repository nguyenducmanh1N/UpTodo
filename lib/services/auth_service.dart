import 'dart:math';

import 'package:flutter/material.dart';

class AuthService {
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username.trim() == 'user@gmail.com' && password.trim() == 'password') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextBool();
  }
}
