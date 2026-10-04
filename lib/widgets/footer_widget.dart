import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final VoidCallback? onLoginPressed;

  const FooterWidget({super.key, this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0ECE1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE1DBCF)),
          ),
          child: Column(
            children: [
              const _GiziWatchLogo(),

              const SizedBox(height: 10),

              const Text(
                'Small steps, better nutrition.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6F756D),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 13),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  _FooterPill(icon: Icons.restaurant_outlined, text: 'Eat'),
                  _FooterPill(icon: Icons.bar_chart_rounded, text: 'Track'),
                  _FooterPill(
                    icon: Icons.favorite_border_rounded,
                    text: 'Grow',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: 45,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F6541),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 13),

              GestureDetector(
                onTap: onLoginPressed,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: Color(0xFF777269)),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: Color(0xFF2F6541),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Text(
          '© 2026 GiziWatch',
          style: TextStyle(
            fontSize: 10,
            color: const Color(0xFF777269).withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _GiziWatchLogo extends StatelessWidget {
  const _GiziWatchLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F3E9),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2F6541), width: 3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6E0D1),
                  shape: BoxShape.circle,
                ),
              ),

              Positioned(
                left: 10,
                top: 9,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0B65E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF76A783),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        const Text(
          'GiziWatch',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFF183C28),
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

class _FooterPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FooterPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0D9CD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF2F6541)),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF536054),
            ),
          ),
        ],
      ),
    );
  }
}
