import 'dart:math';
import 'package:uptodo/models/user/user_dto.dart';

class AuthService {
  Future<UserDTO?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username.trim() == 'user@gmail.com' && password.trim() == 'password') {
      return UserDTO(
        id: '12345',
        email: username.trim(),
        token: '123aaa',
        username: 'User',
        imageUrl: 'personal_image.png',
      );
    }
    return null;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': Random().nextInt(100000).toString(),
      'name': 'New User',
      'email': email.trim(),
      'token': '${Random().nextInt(1000)}'
    };
  }
}
