import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uptodo/repositories/auth_repository.dart';
import 'package:uptodo/services/auth_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/validator/email_validator.dart';
import 'package:uptodo/utils/validator/password_validator.dart';
import 'package:uptodo/widgets/auth/components/custom_button.dart';
import 'package:uptodo/widgets/auth/components/custom_text_field.dart';
import 'package:uptodo/widgets/auth/components/social_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthRepository _authRepository = AuthRepository(AuthService());
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String _errorMessage = '';
  bool _isButtonEnabled = false;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  void dispose() {
    super.dispose();
  }

  void _onEmailChanged(String value) {
    _email = value;
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

  void _onConfirmPasswordChanged(String value) {
    _confirmPassword = value;
    setState(() {
      if (value != _password) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailError == null && _passwordError == null && _confirmPasswordError == null;
    });
  }

  Future<void> _handleRegister() async {
    if (!_isButtonEnabled) return;
    var registerResponse = await _authRepository.register(_email, _password);
    if (registerResponse.isNotEmpty) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    setState(() {
      _errorMessage = 'Registration failed. Please try again.';
    });
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
                  "Register",
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColor.upToDoWhile,
                  ),
                ),
                const SizedBox(height: 24),
                Text("Email",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoKeyPrimary,
                    )),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: "Enter your Email",
                  onChanged: _onEmailChanged,
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
                const SizedBox(height: 16),
                Text("Confirm Password",
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColor.upToDoKeyPrimary,
                    )),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: "Confirm your Password",
                  onChanged: _onConfirmPasswordChanged,
                  obscureText: true,
                  errorText: _confirmPasswordError,
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
                  onPressed: _isButtonEnabled ? _handleRegister : null,
                  label: "Register",
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
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: Text(
                          "Login",
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
