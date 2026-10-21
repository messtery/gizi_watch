import 'package:flutter/material.dart';

import '../widgets/app_text_field.dart';
import '../widgets/footer_widget.dart';
import '../widgets/nutrition_orbit.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  String _passwordStrength() {
    final password = _passwordController.text;

    if (password.isEmpty) {
      return '';
    }

    if (password.length < 6) {
      return 'Weak';
    }

    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (password.length >= 8 && hasNumber && hasSpecial) {
      return 'Strong';
    }

    return 'Fair';
  }

  Color _strengthColor() {
    switch (_passwordStrength()) {
      case 'Strong':
        return const Color(0xFF2F6541);

      case 'Fair':
        return const Color(0xFFE1A64E);

      case 'Weak':
        return const Color(0xFFC86F47);

      default:
        return const Color(0xFFE0DBCF);
    }
  }

  void _register() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Privacy Policy.'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account ready! Your nutrition journey can begin.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopBar(),

                        const SizedBox(height: 20),

                        _buildHeroSection(),

                        const SizedBox(height: 28),

                        _buildForm(),

                        const SizedBox(height: 22),

                        _buildTerms(),

                        const SizedBox(height: 24),

                        PrimaryButton(
                          text: 'Create account',
                          onPressed: _register,
                        ),

                        const SizedBox(height: 20),

                        const FooterWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE3DED3)),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 15,
              color: Color(0xFF263B2D),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F6541),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DED3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DED3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        const Text(
          '1 of 3',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF777269),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Positioned(
          right: -20,
          top: -10,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE7EEF5).withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: NutritionOrbit()),

            const SizedBox(height: 18),

            const Center(
              child: Text(
                'Create your\naccount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 32,
                  height: 0.98,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF183C28),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'One account holds your profile and your family members\' logs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF777269),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(Icons.restaurant_outlined, 'Track meals'),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.insights_outlined, 'Know your needs'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E0D5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: const Color(0xFF2F6541)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF526052),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Full name',
          hint: 'Your name',
          controller: _nameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }

            if (value.trim().length < 2) {
              return 'Name is too short';
            }

            return null;
          },
        ),

        const SizedBox(height: 15),

        AppTextField(
          label: 'Email',
          hint: 'name@email.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }

            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

            if (!emailRegex.hasMatch(value.trim())) {
              return 'Please enter a valid email';
            }

            return null;
          },
        ),

        const SizedBox(height: 15),

        AppTextField(
          label: 'Password',
          hint: 'Create a password',
          controller: _passwordController,
          obscureText: _hidePassword,
          isPassword: true,
          onTogglePassword: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }

            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }

            return null;
          },
        ),

        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildPasswordStrength(),
        ],

        const SizedBox(height: 15),

        AppTextField(
          label: 'Confirm password',
          hint: 'Repeat password',
          controller: _confirmPasswordController,
          obscureText: _hideConfirmPassword,
          isPassword: true,
          onTogglePassword: () {
            setState(() {
              _hideConfirmPassword = !_hideConfirmPassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }

            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordStrength() {
    final strength = _passwordStrength();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == 'Weak'
                      ? _strengthColor()
                      : const Color(0xFFE3DED3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == 'Fair' || strength == 'Strong'
                      ? _strengthColor()
                      : const Color(0xFFE3DED3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength == 'Strong'
                      ? _strengthColor()
                      : const Color(0xFFE3DED3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Text(
          '$strength · Use at least 8 characters with a number or symbol.',
          style: TextStyle(
            color: _strengthColor(),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTerms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _agreeToTerms = !_agreeToTerms;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _agreeToTerms ? const Color(0xFF2F6541) : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: _agreeToTerms
                    ? const Color(0xFF2F6541)
                    : const Color(0xFFD9D3C8),
              ),
            ),
            child: _agreeToTerms
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
        ),

        const SizedBox(width: 9),

        const Expanded(
          child: Text(
            'I agree to the Terms and Privacy Policy, and understand that this app gives guidance, not medical diagnosis.',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.4,
              color: Color(0xFF777269),
            ),
          ),
        ),
      ],
    );
  }
}
