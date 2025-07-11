import 'package:uptodo/models/user/user_dto.dart';
import 'package:uptodo/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<UserDTO?> login(String username, String password) async {
    final response = await _authService.login(username, password);
    return response;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await _authService.register(email, password);
    return response;
  }
}
