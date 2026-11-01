import 'package:flutter/material.dart';

const Color _bg = Color(0xFFF4F2EC);
const Color _green = Color(0xFF3F5B3F);
const Color _ink = Color(0xFF1C1C1A);
const Color _grey = Color(0xFF6B6B66);
const Color _border = Color(0xFFDDD9CF);
const Color _thumb = Color(0xFFD6D0BF);

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recipes',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Video recipes grouped by the nutrient they help with',
                      style: TextStyle(fontSize: 12, color: _grey),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 34,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _Chip(label: 'Rich in iron', selected: true),
                          _Chip(label: 'High protein'),
                          _Chip(label: 'Folate'),
                          _Chip(label: 'Calcium'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _FeaturedVideo(),
                    const SizedBox(height: 8),
                    const Text(
                      'Tumis hati ayam kecap',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '[Channel name]',
                      style: TextStyle(fontSize: 12, color: _grey),
                    ),
                    const SizedBox(height: 12),
                    const _VideoItem(
                      title: 'Sup kacang merah',
                      color: Color(0xFFCDD3C4),
                    ),
                    const SizedBox(height: 9),
                    const _VideoItem(
                      title: 'Semur daging sapi',
                      color: Color(0xFFD6D0BF),
                    ),
                    const SizedBox(height: 9),
                    const _VideoItem(
                      title: 'Oseng tempe kacang panjang',
                      color: Color(0xFFCED4DC),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  const _Chip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 7),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? _green : Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: selected ? _green : _border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : _ink,
        ),
      ),
    );
  }
}

class _FeaturedVideo extends StatelessWidget {
  const _FeaturedVideo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: _thumb,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 11,
            top: 11,
            child: Text(
              '[Video thumbnail]',
              style: TextStyle(fontSize: 11, color: Color(0xFF4A4A45)),
            ),
          ),
          Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFF55554D),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Positioned(
            right: 9,
            bottom: 9,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _ink,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                '[mm:ss]',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoItem extends StatelessWidget {
  final String title;
  final Color color;
  const _VideoItem({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 104,
          height: 62,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFF4F2EC),
            size: 14,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                '[Channel name] · [mm:ss]',
                style: TextStyle(fontSize: 11, color: _grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E5DC))),
      ),
      child: const Row(
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home'),
          _NavItem(icon: Icons.assignment_outlined, label: 'Diary'),
          _NavItem(icon: Icons.show_chart, label: 'Body'),
          _NavItem(
            icon: Icons.rice_bowl_outlined,
            label: 'Recipes',
            selected: true,
          ),
          _NavItem(icon: Icons.article_outlined, label: 'News'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _green : const Color(0xFF3A3A36);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
