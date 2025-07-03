import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptodo/providers/auth_provider.dart';
import 'package:uptodo/repositories/auth_repository.dart';
import 'package:uptodo/services/auth_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/validator/email_validator.dart';
import 'package:uptodo/utils/validator/password_validator.dart';
import 'package:uptodo/widgets/auth/components/custom_button.dart';
import 'package:uptodo/widgets/auth/components/custom_text_field.dart';
import 'package:uptodo/widgets/auth/components/social_button.dart';
import 'package:uptodo/widgets/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _authRepository = AuthRepository(AuthService());
  String? _emailError;
  String? _passwordError;
  String _errorMessage = '';
  bool _isButtonEnabled = false;
  Timer? _debounce;
  String _username = '';
  String _password = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _username = value;
    setState(() {
      _emailError = Email.dirty(value).error?.errorMessage;
      _updateButtonState();
    });
  }

  void _onPasswordChanged(String value) {
    _password = value;
    setState(() {
      _passwordError = Password.dirty(value).error?.errorMessage;
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailError == null && _passwordError == null;
    });
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (!_isButtonEnabled) return;
    final loginResponse = await _authRepository.login(_username, _password);
    if (loginResponse != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login(loginResponse);
      print('Login successful: $loginResponse');
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColor.upToDoWhile,
                  ),
                ),
                const SizedBox(height: 24),
                Text("Username",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoKeyPrimary,
                    )),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: "Enter your Username",
                  onChanged: _onUsernameChanged,
                  errorText: _emailError,
                ),
                const SizedBox(height: 16),
                Text("Password",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoKeyPrimary,
                    )),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: "Enter your Password",
                  onChanged: _onPasswordChanged,
                  obscureText: true,
                  errorText: _passwordError,
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: _isButtonEnabled ? () => _handleLogin(context) : null,
                  label: "Login",
                  isEnabled: _isButtonEnabled,
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                SocialButton(label: "Login with Google", iconPath: 'assets/images/gg_icon.png', onPressed: () {}),
                const SizedBox(height: 12),
                SocialButton(label: "Login with Apple", iconPath: 'assets/images/apple_icon.png', onPressed: () {}),
                const SizedBox(height: 50),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColor.upToDoBorder,
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                          "Register",
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColor.upToDoWhile,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
