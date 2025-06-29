import 'package:flutter/material.dart';
import 'package:uptodo/services/auth_service.dart';
import 'package:uptodo/styles/app_color.dart';
import 'package:uptodo/styles/app_text_styles.dart';
import 'package:uptodo/utils/email_validator.dart';
import 'package:uptodo/utils/password_validator.dart';
import 'package:uptodo/widgets/auth/components/custom_button.dart';
import 'package:uptodo/widgets/auth/components/custom_text_field.dart';
import 'package:uptodo/widgets/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _emailError;
  String? _passwordError;
  String _errorMessage = '';
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _emailError = Email.dirty(_usernameController.text).error?.errorMessage;
      _passwordError = Password.dirty(_passwordController.text).error?.errorMessage;
      _isButtonEnabled = _emailError == null && _passwordError == null;
    });
  }

  Future<void> _handleLogin() async {
    _validateInputs();

    if (!_isButtonEnabled) return;

    bool success = await _authService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      widget.onLogin();
      return;
    }
    setState(() {
      _errorMessage = 'Invalid username or password';
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
                  controller: _usernameController,
                  hintText: "Enter your Username",
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
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: _isButtonEnabled ? _handleLogin : null,
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
