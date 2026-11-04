import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';
import 'diary_page.dart';
import 'body_page.dart';
import 'recipe_page.dart';
import 'news_page.dart';

// ============================================================
// GIZIWATCH THEME
// ============================================================

const Color _bg = Color(0xFFF4F2EC);
const Color _green = Color(0xFF3F5B3F);
const Color _ink = Color(0xFF1C1C1A);
const Color _grey = Color(0xFF6B6B66);
const Color _border = Color(0xFFDDD9CF);
const Color _lightGreen = Color(0xFFEAF0E5);
const Color _orange = Color(0xFFD58B55);

// ============================================================
// DATA MODEL
// ============================================================

class _ActivityPlan {
  final String name;
  final int minutes;
  final String target;

  const _ActivityPlan({
    required this.name,
    required this.minutes,
    required this.target,
  });

  _ActivityPlan copyWith({int? minutes, String? target}) {
    return _ActivityPlan(
      name: name,
      minutes: minutes ?? this.minutes,
      target: target ?? this.target,
    );
  }
}

class _MealPreview {
  final String name;
  final String menu;
  final int kcal;
  final IconData icon;

  const _MealPreview({
    required this.name,
    required this.menu,
    required this.kcal,
    required this.icon,
  });
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _quoteController = PageController();

  int _quoteIndex = 0;

  final List<String> _quotes = [
    'Take care of your body. It is the only place you have to live.',
    'Healthy eating is not about restriction, it is about nourishment.',
    'Small steps every day lead to big changes over time.',
    'Your health is an investment, not an expense.',
    'A healthy outside starts from the inside.',
  ];

  final List<String> _activities = [
    'Lari Pagi',
    'Jalan Pagi',
    'Bersepeda',
    'Yoga',
    'Gym',
    'Senam',
  ];

  final Map<String, IconData> _activityIcons = {
    'Lari Pagi': Icons.directions_run_rounded,
    'Jalan Pagi': Icons.directions_walk_rounded,
    'Bersepeda': Icons.directions_bike_rounded,
    'Yoga': Icons.self_improvement_rounded,
    'Gym': Icons.fitness_center_rounded,
    'Senam': Icons.sports_gymnastics_rounded,
  };

  List<_ActivityPlan> _selectedActivities = [];

  // Data demo. Nantinya dapat diganti dengan data dari DiaryPage.
  final List<_MealPreview> _meals = const [
    _MealPreview(
      name: 'Sarapan',
      menu: 'Nasi putih dan menu sarapan',
      kcal: 260,
      icon: Icons.wb_twilight_rounded,
    ),
    _MealPreview(
      name: 'Makan siang',
      menu: 'Nasi, lauk, dan sayuran',
      kcal: 480,
      icon: Icons.wb_sunny_outlined,
    ),
    _MealPreview(
      name: 'Makan malam',
      menu: 'Belum ada makanan',
      kcal: 0,
      icon: Icons.nights_stay_outlined,
    ),
  ];

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }

  // ==========================================================
  // DATE AND TIME
  // ==========================================================

  String _getDay(DateTime date) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return days[date.weekday - 1];
  }

  String _getMonth(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[date.month - 1];
  }

  String _getTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute WIB';
  }

  final String _userName = 'OrangHave';

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 11) {
      return 'Selamat Pagi,';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang,';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore,';
    }

    return 'Selamat Malam,';
  }

  // ==========================================================
  // NAVIGATION
  // ==========================================================

  void _navigateTo(int index) {
    final pages = <Widget>[
      const HomePage(),
      const DiaryPage(),
      const BodyPage(),
      const RecipePage(),
      const NewsPage(),
    ];

    if (index == 0) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => pages[index]),
    );
  }

  void _openDiary({String meal = 'Sarapan'}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DiaryPage(openAddFood: true, initialMeal: meal),
      ),
    );
  }

  // ==========================================================
  // ACTIVITY MANAGEMENT
  // ==========================================================

  Future<void> _addActivity(String activity) async {
    final exists = _selectedActivities.any((item) => item.name == activity);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$activity sudah ada dalam agenda.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await _showActivityDialog(activity);

    if (result != null && mounted) {
      setState(() {
        _selectedActivities.add(result);
      });
    }
  }

  Future<_ActivityPlan?> _showActivityDialog(
    String activity, {
    _ActivityPlan? existing,
  }) async {
    final minutesController = TextEditingController(
      text: existing?.minutes.toString() ?? '30',
    );

    final targetController = TextEditingController(
      text: existing?.target ?? '',
    );

    final result = await showDialog<_ActivityPlan>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            existing == null ? 'Atur aktivitas' : 'Ubah aktivitas',
            style: const TextStyle(
              color: _ink,
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: const TextStyle(
                    color: _green,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Durasi (menit)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 7),
                TextField(
                  controller: minutesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Contoh: 30',
                    filled: true,
                    fillColor: _bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Target aktivitas',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 7),
                TextField(
                  controller: targetController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Contoh: 3 km atau 5.000 langkah',
                    filled: true,
                    fillColor: _bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal', style: TextStyle(color: _grey)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final minutes = int.tryParse(minutesController.text);

                if (minutes == null || minutes <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Masukkan durasi yang valid.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  _ActivityPlan(
                    name: activity,
                    minutes: minutes,
                    target: targetController.text.trim().isEmpty
                        ? 'Belum ada target'
                        : targetController.text.trim(),
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    minutesController.dispose();
    targetController.dispose();

    return result;
  }

  Future<void> _editActivity(int index) async {
    final activity = _selectedActivities[index];

    final result = await _showActivityDialog(activity.name, existing: activity);

    if (result != null && mounted) {
      setState(() {
        _selectedActivities[index] = result;
      });
    }
  }

  void _deleteActivity(int index) {
    final activity = _selectedActivities[index];

    setState(() {
      _selectedActivities.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${activity.name} dihapus dari agenda.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showActivityPicker() async {
    final available = _activities
        .where((name) => !_selectedActivities.any((item) => item.name == name))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua aktivitas sudah ditambahkan.')),
      );
      return;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah aktivitas',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Pilih aktivitas yang ingin kamu lakukan.',
                style: TextStyle(fontSize: 12, color: _grey),
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: available.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final name = available[index];

                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () => Navigator.pop(context, name),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_activityIcons[name], color: _green, size: 20),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: _ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (selected != null && mounted) {
      await _addActivity(selected);
    }
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        boxShadow: [
          BoxShadow(
            color: _ink.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.eco_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'GiziWatch',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: _green,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('Notifications'),
                    content: const Text(
                      'Belum ada notifikasi baru.',
                      style: TextStyle(color: _grey),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Tutup',
                          style: TextStyle(color: _green),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: _ink,
                size: 25,
              ),
            ),
            IconButton(
              tooltip: 'Profile',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('My Profile'),
                    content: const Text(
                      'Informasi profil pengguna GiziWatch.',
                      style: TextStyle(color: _grey),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Tutup',
                          style: TextStyle(color: _green),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.account_circle_outlined,
                color: _ink,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // GREETING, DATE AND WEATHER
  // ==========================================================

  Widget _buildGreeting() {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        decoration: BoxDecoration(
          color: _lightGreen,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: _green.withOpacity(0.08)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getGreeting(),
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _green,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _userName,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: _green,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Bagaimana kabarmu hari ini?',
                    softWrap: true,
                    style: TextStyle(fontSize: 10, color: _grey, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.78),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_getDay(now)}, ${now.day} ${_getMonth(now)}',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getTime(now),
                      style: const TextStyle(
                        fontSize: 9,
                        color: _grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 7),
            Container(
              width: 48,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: _orange.withOpacity(0.14),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Column(
                children: [
                  Icon(Icons.wb_cloudy_rounded, color: _orange, size: 22),
                  SizedBox(height: 3),
                  Text(
                    '28°C',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: _ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEALTH QUOTES CAROUSEL
  // ==========================================================

  Widget _buildQuotes() {
    return Column(
      children: [
        SizedBox(
          height: 125,
          child: PageView.builder(
            controller: _quoteController,
            itemCount: _quotes.length,
            onPageChanged: (index) {
              setState(() {
                _quoteIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      color: Color(0xFFC9D6BE),
                      size: 42,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DAILY HEALTH QUOTE',
                            style: TextStyle(
                              color: Color(0xFFD7E1D0),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _quotes[index],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_quotes.length, (index) {
            final selected = _quoteIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: selected ? 19 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: selected ? _green : _border,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ==========================================================
  // TODAY'S AGENDA
  // ==========================================================

  Widget _buildAgenda() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agenda Hari Ini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: _ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _selectedActivities.isEmpty
              ? 'Pilih aktivitas untuk mengatur rutinitasmu.'
              : '${_selectedActivities.length} aktivitas dalam agenda hari ini',
          style: const TextStyle(fontSize: 11, color: _grey),
        ),
        const SizedBox(height: 13),

        // DEFAULT: GRID VIEW
        if (_selectedActivities.isEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activities.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 11,
              mainAxisSpacing: 11,
              childAspectRatio: 2.35,
            ),
            itemBuilder: (context, index) {
              final name = _activities[index];

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _addActivity(name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _lightGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _activityIcons[name],
                            color: _green,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          color: _green,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        else
          Column(
            children: [
              ...List.generate(_selectedActivities.length, (index) {
                final activity = _selectedActivities[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: _border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 39,
                            height: 39,
                            decoration: BoxDecoration(
                              color: _lightGreen,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(
                              _activityIcons[activity.name],
                              color: _green,
                              size: 21,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.name,
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${activity.minutes} menit • ${activity.target}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: _grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => _editActivity(index),
                            style: TextButton.styleFrom(
                              foregroundColor: _green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              minimumSize: Size.zero,
                            ),
                            child: const Text(
                              'Ubah',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Hapus aktivitas',
                            onPressed: () => _deleteActivity(index),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFC56A57),
                              size: 20,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 2),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: _showActivityPicker,
                  icon: const Icon(Icons.add_rounded, size: 19),
                  label: const Text('Tambah Aktivitas'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _green,
                    side: const BorderSide(color: _green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget _buildSectionHeader(String title, String action, VoidCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: _green,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: Row(
            children: [
              Text(
                action,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.arrow_forward_ios_rounded, size: 11),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MEALS PREVIEW
  // ==========================================================

  Widget _buildMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meals',
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        ..._meals.map((meal) {
          final isEmpty = meal.kcal <= 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _lightGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(meal.icon, color: _green, size: 22),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.menu,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: isEmpty ? _orange : _grey,
                          fontWeight: isEmpty
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                if (isEmpty)
                  TextButton.icon(
                    onPressed: () => _openDiary(meal: meal.name),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Tambah'),
                    style: TextButton.styleFrom(
                      foregroundColor: _green,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      minimumSize: const Size(0, 36),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${meal.kcal} kcal',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: _green,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Estimasi energi',
                        style: TextStyle(fontSize: 9, color: _grey),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ==========================================================
  // RECIPES PREVIEW
  // ==========================================================

  Widget _buildRecipes() {
    final recipes = [
      {
        'title': 'Tumis hati ayam kecap',
        'category': 'Rich in iron',
        'icon': Icons.restaurant_rounded,
      },
      {
        'title': 'Sup kacang merah',
        'category': 'High protein',
        'icon': Icons.soup_kitchen_rounded,
      },
      {
        'title': 'Semur daging sapi',
        'category': 'Rich in iron',
        'icon': Icons.ramen_dining_rounded,
      },
    ];

    return Column(
      children: [
        _buildSectionHeader('Recipes', 'See all', () => _navigateTo(3)),
        const SizedBox(height: 8),
        SizedBox(
          height: 142,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return InkWell(
                onTap: () => _navigateTo(3),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 145,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: _border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _lightGreen,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          recipe['icon'] as IconData,
                          size: 30,
                          color: _green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recipe['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        recipe['category'] as String,
                        style: const TextStyle(fontSize: 9, color: _grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // NEWS PREVIEW
  // ==========================================================

  Widget _buildNews() {
    final news = [
      {
        'category': 'Nutrition',
        'title':
            'Essential Animal Protein Intake to Prevent Stunting in Children',
      },
      {
        'category': 'Stunting',
        'title': 'Identifying Key Symptoms of Stunting and Early Intervention',
      },
      {
        'category': 'Malnutrition',
        'title':
            'Long-term Effects of Chronic Undernutrition on Cognitive Function',
      },
    ];

    return Column(
      children: [
        _buildSectionHeader('Latest News', 'See all', () => _navigateTo(4)),
        const SizedBox(height: 8),
        ...news.map(
          (item) => InkWell(
            onTap: () => _navigateTo(4),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      color: _lightGreen,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.article_outlined,
                      color: _green,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['category']!,
                          style: const TextStyle(
                            color: _green,
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['title']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: _grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: SafeArea(bottom: false, child: _buildAppBar()),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    wide ? 28 : 0,
                    12,
                    wide ? 28 : 0,
                    22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(),
                      const SizedBox(height: 20),

                      _buildQuotes(),
                      const SizedBox(height: 23),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: _buildAgenda(),
                      ),
                      const SizedBox(height: 23),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: _buildMeals(),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: _buildRecipes(),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: _buildNews(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: _navigateTo),
    );
  }
}
