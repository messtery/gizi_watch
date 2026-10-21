import 'package:flutter/material.dart';

import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';
import '../widgets/footer_widget.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool rememberMe = false;
  bool showPassword = false;

  String? emailError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Login functionality akan ditambahkan nanti.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3EC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 29,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================
                  // BACK BUTTON
                  // =========================
                  const SizedBox(height: 12),

                  Container(
                    width: 37,
                    height: 37,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 17,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                  ),

                  // =========================
                  // LOGO
                  // =========================
                  const SizedBox(height: 24),

                  const AppLogo(
                    size: 96,
                  ),

                  // =========================
                  // TITLE
                  // =========================
                  const SizedBox(height: 23),

                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      color: Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Log in to continue tracking your family\'s nutrition.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6C6C6C),
                      height: 1.3,
                    ),
                  ),

                  // =========================
                  // EMAIL
                  // =========================
                  const SizedBox(height: 19),

                  AppTextField(
                    label: 'Email',
                    hint: 'name@email.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,

                    errorText: emailError,

                    onChanged: (value) {
                      setState(() {
                        if (value.trim().isEmpty) {
                          emailError = null;
                          return;
                        }

                        final emailRegex = RegExp(
                          r'^[\w\.-]+@gmail\.com$',
                          caseSensitive: false,
                        );

                        if (!emailRegex.hasMatch(
                          value.trim(),
                        )) {
                          emailError =
                              'Please enter a valid email address';
                        } else {
                          emailError = null;
                        }
                      });
                    },

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your email';
                      }

                      final emailRegex = RegExp(
                        r'^[\w\.-]+@gmail\.com$',
                        caseSensitive: false,
                      );

                      if (!emailRegex.hasMatch(
                        value.trim(),
                      )) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),

                  // =========================
                  // PASSWORD
                  // =========================
                  const SizedBox(height: 13),

                  AppTextField(
                    label: 'Password',
                    hint: 'Password',
                    controller: passwordController,

                    obscureText: !showPassword,

                    isPassword: true,

                    onTogglePassword: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return 'Please enter your password';
                      }

                      return null;
                    },
                  ),

                  // =========================
                  // REMEMBER ME + FORGOT
                  // =========================
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe =
                                      value ?? false;
                                });
                              },
                              activeColor:
                                  const Color(0xFF2F5D3A),
                              checkColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFF2F5D3A),
                                width: 1.5,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize
                                      .shrinkWrap,
                            ),
                          ),

                          const SizedBox(width: 5),

                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF676767),
                            ),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          // Forgot password
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF477052),
                            decoration:
                                TextDecoration.underline,
                            decorationColor:
                                Color(0xFF477052),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // =========================
                  // LOGIN BUTTON
                  // =========================
                  const SizedBox(height: 88),

                  PrimaryButton(
                    text: 'Log in',
                    onPressed: _login,
                  ),

                  // =========================
                  // FOOTER
                  // =========================
                  const SizedBox(height: 20),

                  FooterWidget(
                    isLoginPage: true,
                    onSignUpPressed: () {
                      // Navigasi ke RegisterPage
                      // akan ditambahkan nanti.
                    },
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}