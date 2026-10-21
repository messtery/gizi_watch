import 'package:flutter/material.dart';

// ===== Warna (diambil dari gambar) =====
const Color kBackground = Color(0xFFF5F3EC);
const Color kTextDark = Color(0xFF1A1A1A);
const Color kTextGrey = Color(0xFF5A5A55);
const Color kBorder = Color(0xFFE6E2D6);
const Color kTrack = Color(0xFFECE9E1);
const Color kBrown = Color(0xFFA85F33);
const Color kGreen = Color(0xFF3D5F43);
const Color kAlertBg = Color(0xFFF7E9DF);
const Color kAlertBorder = Color(0xFFEBCFBD);
const Color kBarLight = Color(0xFFD3B8A0);
const Color kLabelBrown = Color(0xFF6B5E55);

// Ukuran desain (sesuai gambar). Seluruh layar akan di-scale proporsional
// sehingga tampilan konstan: tidak ada scroll ke bawah maupun ke samping.
const double kDesignWidth = 588;
const double kDesignHeight = 1275;

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: kDesignWidth,
            height: kDesignHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 36, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 22),
                  _buildNutrientCard(),
                  const SizedBox(height: 23),
                  _buildIronAlert(),
                  const SizedBox(height: 23),
                  _buildSectionTitle('Foods that add iron'),
                  const SizedBox(height: 12),
                  _buildFoodChips(),
                  const SizedBox(height: 23),
                  _buildRecipesHeader(),
                  const SizedBox(height: 11),
                  _buildRecipes(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader() {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: kBorder, width: 1.5),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: kTextDark,
            ),
          ),
          const SizedBox(width: 18),
          const Text(
            'Nutrients today',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 35,
              fontWeight: FontWeight.w800,
              color: kTextDark,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu nutrisi ----------
  Widget _buildNutrientCard() {
    return Container(
      width: 528,
      height: 338,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kBorder, width: 1.5),
      ),
      child: Column(
        children: [
          _nutrientRow('Iron', '7 / 18 mg', 7 / 18, kBrown),
          const SizedBox(height: 22.5),
          _nutrientRow('Calcium', '540 / 1000 mg', 0.54, kGreen),
          const SizedBox(height: 22.5),
          _nutrientRow('Folate', '190 / 400 mcg', 0.475, kBrown),
          const SizedBox(height: 22.5),
          _nutrientRow('Zinc', '6 / 8 mg', 0.75, kGreen),
          const SizedBox(height: 22.5),
          _nutrientRow('Vitamin A', '480 / 600 mcg', 0.8, kGreen),
        ],
      ),
    );
  }

  Widget _nutrientRow(String name, String value, double progress, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  color: kTextGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            width: double.infinity,
            child: Stack(
              children: [
                Container(color: kTrack),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Kartu peringatan zat besi ----------
  Widget _buildIronAlert() {
    return Container(
      width: 528,
      height: 209,
      padding: const EdgeInsets.fromLTRB(22, 23, 22, 0),
      decoration: BoxDecoration(
        color: kAlertBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kAlertBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 28,
            child: Text(
              'Iron under half of target, 3 days running',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: kTextDark,
              ),
            ),
          ),
          const SizedBox(height: 27),
          SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _dayBar(59, kBarLight),
                _dayBar(72, kBarLight),
                _dayBar(50, kBarLight),
                _dayBar(63, kBarLight),
                _dayBar(34, kBrown),
                _dayBar(29, kBrown),
                _dayBar(32, kBrown),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _DayLabel('Thu'),
                _DayLabel('Fri'),
                _DayLabel('Sat'),
                _DayLabel('Sun'),
                _DayLabel('Mon'),
                _DayLabel('Tue'),
                _DayLabel('Wed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayBar(double height, Color color) {
    return Container(
      width: 59,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // ---------- Judul section ----------
  Widget _buildSectionTitle(String title) {
    return SizedBox(
      height: 30,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kTextDark,
          ),
        ),
      ),
    );
  }

  // ---------- Chip makanan ----------
  Widget _buildFoodChips() {
    return SizedBox(
      width: 528,
      child: Wrap(
        spacing: 13,
        runSpacing: 13,
        children: [
          _chip('Hati ayam', 132),
          _chip('Kacang merah', 174),
          _chip('Daging sapi', 149),
          _chip('Tempe', 103),
        ],
      ),
    );
  }

  Widget _chip(String label, double width) {
    return Container(
      width: width,
      height: 51,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: kBorder, width: 1.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: kTextDark,
        ),
      ),
    );
  }

  // ---------- Header resep ----------
  Widget _buildRecipesHeader() {
    return SizedBox(
      width: 528,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Recipes rich in iron',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: kTextDark,
            ),
          ),
          Text(
            'See all',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: kGreen,
              decoration: TextDecoration.underline,
              decorationColor: kGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu resep ----------
  Widget _buildRecipes() {
    return SizedBox(
      width: 528,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _recipe('Tumis hati ayam kecap', const Color(0xFFD6CEBF), 257),
          const SizedBox(width: 15),
          _recipe('Sup kacang merah', const Color(0xFFCDD3C5), 256),
        ],
      ),
    );
  }

  Widget _recipe(String title, Color color, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 136,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.play_arrow, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 24,
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: kTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  const _DayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: kLabelBrown,
      ),
    );
  }
}
