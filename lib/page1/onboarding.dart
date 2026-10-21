import 'package:flutter/material.dart';

import '../pages/register_page.dart';
import '../pages/login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  // Warna sesuai gambar
  static const Color _bgColor = Color(0xFFF5F3EC);
  static const Color _darkGreen = Color(0xFF1F3A2B);
  static const Color _logoGreen = Color(0xFF2F4A2F);
  static const Color _buttonGreen = Color(0xFF3F5B3A);
  static const Color _outerCircle = Color(0xFFE8E1D3);
  static const Color _blobYellow = Color(0xFFDDB871);
  static const Color _blobGreen = Color(0xFF8BA888);
  static const Color _blobBrown = Color(0xFFB87555);
  static const Color _dotBlue = Color(0xFFDCE6F2);
  static const Color _dotPeach = Color(0xFFF2D9C8);
  static const Color _borderGrey = Color(0xFFD8D4C8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        const Text(
                          'GiziWatch',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _logoGreen,
                          ),
                        ),

                        const Spacer(),

                        // Ilustrasi piring
                        Center(child: _buildIllustration()),

                        const Spacer(),

                        // Tombol Get started
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Get started',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tombol I already have an account
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _bgColor,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: _borderGrey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'I already have an account',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildIllustration() {
    return SizedBox(
      width: 290,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Lingkaran besar (beige)
          Container(
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              color: _outerCircle,
              shape: BoxShape.circle,
            ),
          ),

          // Lingkaran kecil biru (kanan atas)
          Positioned(
            right: 0,
            top: 24,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: _dotBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Lingkaran kecil peach (kiri bawah)
          Positioned(
            left: 4,
            bottom: 28,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: _dotPeach,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Piring: cincin hijau tua + bagian dalam putih
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _darkGreen, width: 9),
            ),
          ),

          // 3 bentuk saling menyatu (menempel/overlap)
          SizedBox(
            width: 120,
            height: 100,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Kuning (lonjong, kiri atas)
                Positioned(
                  left: 4,
                  top: 14,
                  child: Container(
                    width: 70,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: _blobYellow,
                      borderRadius: BorderRadius.all(Radius.elliptical(70, 52)),
                    ),
                  ),
                ),
                // Hijau (bulat, kanan atas)
                Positioned(
                  left: 58,
                  top: 0,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: _blobGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Coklat (lonjong, bawah)
                Positioned(
                  left: 34,
                  top: 52,
                  child: Container(
                    width: 64,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: _blobBrown,
                      borderRadius: BorderRadius.all(Radius.elliptical(64, 40)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
