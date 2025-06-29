import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uptodo/services/auth_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/email_validator.dart';
import 'package:uptodo/utils/password_validator.dart';
import 'package:uptodo/widgets/auth/components/custom_button.dart';
import 'package:uptodo/widgets/auth/components/custom_text_field.dart';
import 'package:uptodo/widgets/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String _errorMessage = '';
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswordMatch() {
    if (_passwordController.text != _confirmPasswordController.text) {
      _confirmPasswordError = 'Passwords do not match';
      return;
    }
    _confirmPasswordError = null;
  }

  void _validateInputs() {
    setState(() {
      _emailError = Email.dirty(_emailController.text).error?.errorMessage;
      _passwordError = Password.dirty(_passwordController.text).error?.errorMessage;
      _validatePasswordMatch();
      _isButtonEnabled = _emailError == null && _passwordError == null && _confirmPasswordError == null;
    });
  }

  Future<void> _handleRegister() async {
    _validateInputs();
    if (!_isButtonEnabled) return;

    bool success = await _authService.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!success) {
      setState(() {
        _errorMessage = 'Registration failed. Please try again.';
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(onLogin: () {}),
      ),
    );
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
                  style: AppTextStyles.uptododisplaylarge.copyWith(
                    color: AppColor.uptodowhite,
                  ),
                ),
                const SizedBox(height: 24),
                Text("Username",
                    style: AppTextStyles.uptododisplaysmall.copyWith(
                      color: AppColor.uptodokeycolorsprimary,
                    )),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Enter your Email",
                  onChanged: _validateInputs,
                ),
                const SizedBox(height: 16),
                Text("Password",
                    style: AppTextStyles.uptododisplaysmall.copyWith(
                      color: AppColor.uptodokeycolorsprimary,
                    )),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Enter your Password",
                  onChanged: _validateInputs,
                  obscureText: true,
                ),
                Text("Confirm Password",
                    style: AppTextStyles.uptododisplaysmall.copyWith(
                      color: AppColor.uptodokeycolorsprimary,
                    )),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm your Password",
                  onChanged: _validateInputs,
                  obscureText: true,
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12),
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
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.uptodoprimary, width: 1.5),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppColor.uptodoblack,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/gg_icon.png'),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Text("Login with Google",
                            style: AppTextStyles.uptododisplaysmall.copyWith(
                              color: AppColor.uptodowhite,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.uptodoprimary, width: 1.5),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppColor.uptodoblack,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/apple_icon.png'),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Text("Login with Apple",
                            style: AppTextStyles.uptododisplaysmall.copyWith(
                              color: AppColor.uptodowhite,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: AppTextStyles.uptododisplaysmall.copyWith(
                            color: AppColor.uptodoBoder,
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                          "Register",
                          style: AppTextStyles.uptododisplaysmall.copyWith(
                            color: AppColor.uptodowhite,
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
