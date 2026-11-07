import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/food_diary_widgets.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_page.dart';
import 'body_page.dart';
import 'recipe_page.dart';
import 'news_page.dart';

class DiaryPage extends StatefulWidget {
  final bool openAddFood;
  final String initialMeal;

  const DiaryPage({
    super.key,
    this.openAddFood = false,
    this.initialMeal = 'Sarapan',
  });

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  static const double dailyKcalTarget = 2250;
  static const double proteinTarget = 80;
  static const double fatTarget = 65;
  static const double carbsTarget = 300;

  // Pengaturan porsi
  static const double _portionStep = 25;
  static const double _maxGrams = 1000;
  static const double _foodRowHeight = 64;

  static const List<String> _meals = [
    'Sarapan',
    'Makan siang',
    'Makan malam',
    'Camilan',
  ];
  static const List<String> _filters = ['Terakhir', 'Favorit', 'Semua'];

  DateTime _selectedDate = DateTime.now();
  int _nextEntryId = 10;

  // State mode "tambah makanan" (inline di halaman yang sama)
  String? _addingMeal;
  String _filter = 'Semua';
  String _query = '';
  final Map<String, double> _selected = {}; // foodId -> gram
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _foodListController = ScrollController();

  // Data pendukung chip "Terakhir" dan "Favorit"
  final List<String> _recentIds = [];
  final Set<String> _favoriteIds = {};

  late final Map<String, List<DiaryEntry>> _entriesByDate = {
    _dateKey(DateTime.now()): [
      DiaryEntry(id: 'e1', food: foodCatalog[0], grams: 200, meal: 'Sarapan'),
      DiaryEntry(id: 'e2', food: foodCatalog[10], grams: 60, meal: 'Sarapan'),
      DiaryEntry(
        id: 'e3',
        food: foodCatalog[0],
        grams: 200,
        meal: 'Makan siang',
      ),
      DiaryEntry(
        id: 'e4',
        food: foodCatalog[26],
        grams: 100,
        meal: 'Makan siang',
      ),
      DiaryEntry(
        id: 'e5',
        food: foodCatalog[21],
        grams: 50,
        meal: 'Makan siang',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();

    // Seed chip "Terakhir" dari catatan yang sudah ada
    for (final list in _entriesByDate.values) {
      for (final e in list.reversed) {
        if (!_recentIds.contains(e.food.id)) _recentIds.add(e.food.id);
      }
    }

    if (widget.openAddFood) {
      _addingMeal = widget.initialMeal;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _foodListController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Helper data
  // ---------------------------------------------------------------------------

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  List<DiaryEntry> get _todayEntries =>
      _entriesByDate[_dateKey(_selectedDate)] ?? [];

  int _mealKcal(String meal) => _todayEntries
      .where((e) => e.meal == meal)
      .fold(0, (sum, e) => sum + e.kcal.round());
  double _totalKcal() =>
      _todayEntries.fold<double>(0.0, (sum, e) => sum + e.kcal);
  double _totalProtein() =>
      _todayEntries.fold<double>(0.0, (sum, e) => sum + e.protein);
  double _totalFat() =>
      _todayEntries.fold<double>(0.0, (sum, e) => sum + e.fat);
  double _totalCarbs() =>
      _todayEntries.fold<double>(0.0, (sum, e) => sum + e.carbs);

  FoodItem _foodById(String id) => foodCatalog.firstWhere((f) => f.id == id);

  double get _pendingKcal => _selected.entries.fold<double>(
    0.0,
    (sum, e) => sum + _foodById(e.key).kcalFor(e.value),
  );

  List<FoodItem> get _visibleFoods {
    late final List<FoodItem> base;
    switch (_filter) {
      case 'Terakhir':
        base = _recentIds.map(_foodById).toList();
        break;
      case 'Favorit':
        base = foodCatalog.where((f) => _favoriteIds.contains(f.id)).toList();
        break;
      default:
        base = foodCatalog.toList();
    }
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return base;
    return base.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  String _prettyDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ---------------------------------------------------------------------------
  // Aksi tanggal
  // ---------------------------------------------------------------------------

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'Pilih tanggal diary',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: diaryGreen,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: diaryDarkGreen,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _changeDay(int days) =>
      setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));

  // ---------------------------------------------------------------------------
  // Aksi mode tambah makanan
  // ---------------------------------------------------------------------------

  void _resetAddState() {
    _addingMeal = null;
    _filter = 'Semua';
    _query = '';
    _selected.clear();
    _searchController.clear();
  }

  Future<void> _startAdding(String meal) async {
    if (_addingMeal == meal) return;

    // Cegah kehilangan pilihan tanpa sengaja saat pindah ke waktu makan lain
    if (_addingMeal != null && _selected.isNotEmpty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Buang pilihan?'),
          content: Text(
            '${_selected.length} makanan yang dipilih untuk $_addingMeal belum disimpan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lanjut memilih'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: diaryTerracotta),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Buang'),
            ),
          ],
        ),
      );
      if (discard != true || !mounted) return;
    }

    setState(() {
      _resetAddState();
      _addingMeal = meal;
    });
  }

  void _cancelAdding() => setState(_resetAddState);

  void _setSelectedGrams(String foodId, double grams) {
    final safe = grams.clamp(0, _maxGrams).toDouble();
    setState(() {
      if (safe <= 0) {
        _selected.remove(foodId);
      } else {
        _selected[foodId] = safe;
      }
    });
  }

  void _toggleFavorite(String foodId) {
    setState(() {
      if (!_favoriteIds.remove(foodId)) _favoriteIds.add(foodId);
    });
  }

  Future<void> _typeGrams(FoodItem food) async {
    final controller = TextEditingController(
      text: (_selected[food.id] ?? 0).round().toString(),
    );
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          food.name,
          style: const TextStyle(
            color: diaryDarkGreen,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Berat (0–${_maxGrams.round()})',
            suffixText: 'g',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: diaryGreen),
            onPressed: () {
              final parsed = double.tryParse(controller.text.trim());
              if (parsed == null || parsed < 0 || parsed > _maxGrams) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Masukkan berat antara 0–${_maxGrams.round()} gram.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              Navigator.pop(context, parsed);
            },
            child: const Text('Atur'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) _setSelectedGrams(food.id, result);
  }

  void _saveSelected() {
    final meal = _addingMeal;
    if (meal == null || _selected.isEmpty) return;

    final dateKey = _dateKey(_selectedDate);
    final list = List<DiaryEntry>.from(_todayEntries);
    final addedIds = <String>[];

    _selected.forEach((foodId, grams) {
      final id = 'e${_nextEntryId++}';
      addedIds.add(id);
      list.add(
        DiaryEntry(id: id, food: _foodById(foodId), grams: grams, meal: meal),
      );
      _recentIds
        ..remove(foodId)
        ..insert(0, foodId);
    });

    final count = addedIds.length;
    setState(() {
      _entriesByDate[dateKey] = list;
      _resetAddState();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$count makanan ditambahkan ke $meal.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: diaryDarkGreen,
          action: SnackBarAction(
            label: 'URUNGKAN',
            textColor: Colors.white,
            onPressed: () {
              if (!mounted) return;
              setState(() {
                final current = List<DiaryEntry>.from(
                  _entriesByDate[dateKey] ?? const <DiaryEntry>[],
                )..removeWhere((e) => addedIds.contains(e.id));
                _entriesByDate[dateKey] = current;
              });
            },
          ),
        ),
      );
  }

  // ---------------------------------------------------------------------------
  // Aksi ubah / hapus catatan
  // ---------------------------------------------------------------------------

  void _updateEntryGrams(DiaryEntry entry, double grams) {
    final dateKey = _dateKey(_selectedDate);
    final list = List<DiaryEntry>.from(_todayEntries);
    final index = list.indexWhere((e) => e.id == entry.id);
    if (index < 0) return;
    list[index] = DiaryEntry(
      id: entry.id,
      food: entry.food,
      grams: grams,
      meal: entry.meal,
    );
    setState(() => _entriesByDate[dateKey] = list);
  }

  Future<void> _showEditSheet(DiaryEntry entry) async {
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditPortionSheet(
        entry: entry,
        step: _portionStep,
        maxGrams: _maxGrams,
      ),
    );
    if (result == null || !mounted) return;

    if (result < 0) {
      await _deleteEntry(entry);
    } else {
      _updateEntryGrams(entry, result);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Porsi makanan berhasil diperbarui.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: diaryDarkGreen,
          ),
        );
    }
  }

  Future<void> _deleteEntry(DiaryEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus makanan?'),
        content: Text(
          '${entry.food.name} akan dihapus dari diary tanggal ${_prettyDate(_selectedDate)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: diaryTerracotta),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final dateKey = _dateKey(_selectedDate);
      final previousEntries = List<DiaryEntry>.from(
        _entriesByDate[dateKey] ?? const <DiaryEntry>[],
      );
      final removedIndex = previousEntries.indexWhere((e) => e.id == entry.id);
      setState(() {
        _entriesByDate[dateKey] = List<DiaryEntry>.from(previousEntries)
          ..removeWhere((e) => e.id == entry.id);
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${entry.food.name} dihapus dari diary.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: diaryDarkGreen,
            action: SnackBarAction(
              label: 'URUNGKAN',
              textColor: Colors.white,
              onPressed: () {
                if (!mounted) return;
                setState(() {
                  final currentEntries = List<DiaryEntry>.from(
                    _entriesByDate[dateKey] ?? const <DiaryEntry>[],
                  );
                  if (!currentEntries.any((item) => item.id == entry.id)) {
                    final insertAt = removedIndex.clamp(
                      0,
                      currentEntries.length,
                    );
                    currentEntries.insert(insertAt, entry);
                    _entriesByDate[dateKey] = currentEntries;
                  }
                });
              },
            ),
          ),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final consumed = _totalKcal();
    final remaining = math.max(0.0, dailyKcalTarget - consumed);
    final progress = (consumed / dailyKcalTarget).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: diaryCream,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: diaryCream,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        scrolledUnderElevation: 3,
        shadowColor: diaryDarkGreen.withOpacity(0.14),
        toolbarHeight: 76,
        titleSpacing: 16,

        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: diaryGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.eco_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 11),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GiziWatch',
                  style: TextStyle(
                    fontSize: 12,
                    color: diaryGreen,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Food diary',
                  style: TextStyle(
                    fontSize: 23,
                    color: diaryDarkGreen,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          // Notification Button
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      color: diaryDarkGreen,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  content: const Text(
                    'Belum ada notifikasi baru.',
                    style: TextStyle(color: diaryDarkGreen),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          color: diaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: diaryDarkGreen,
              size: 25,
            ),
          ),

          // Profile Button
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'My Profile',
                    style: TextStyle(
                      color: diaryDarkGreen,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  content: const Text(
                    'Informasi profil pengguna GiziWatch.',
                    style: TextStyle(color: diaryDarkGreen),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          color: diaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: diaryDarkGreen,
              size: 26,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 700;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        wide ? 28 : 16,
                        8,
                        wide ? 28 : 16,
                        12,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildDatePicker(),
                          const SizedBox(height: 12),
                          _buildSummaryCard(consumed, remaining, progress),
                          const SizedBox(height: 16),
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: _mealSections().take(2).toList(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    children: _mealSections().skip(2).toList(),
                                  ),
                                ),
                              ],
                            )
                          else
                            ..._mealSections(),
                          _buildNutritionNote(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          final pages = <Widget>[
            const HomePage(),
            const DiaryPage(),
            const BodyPage(),
            const RecipePage(),
            const NewsPage(),
          ];
          if (index != 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => pages[index]),
            );
          }
        },
      ),
    );
  }

  Widget _buildDatePicker() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: diaryLine),
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Hari sebelumnya',
          onPressed: () => _changeDay(-1),
          icon: const Icon(Icons.chevron_left),
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _pickDate,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text(
                    _prettyDate(_selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: diaryDarkGreen,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Ketuk untuk pilih tanggal',
                    style: TextStyle(fontSize: 10, color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Hari berikutnya',
          onPressed: () => _changeDay(1),
          icon: const Icon(Icons.chevron_right),
          visualDensity: VisualDensity.compact,
        ),
      ],
    ),
  );

  Widget _buildSummaryCard(
    double consumed,
    double remaining,
    double progress,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: diaryLine.withOpacity(0.8)),
      boxShadow: [
        BoxShadow(
          color: diaryDarkGreen.withOpacity(0.035),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kalori hari ini',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatKcal(consumed),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: diaryDarkGreen,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'kcal',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: remaining == 0
                    ? const Color(0xFFFFF0E8)
                    : const Color(0xFFEAF3E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                remaining == 0
                    ? 'Target tercapai'
                    : '${formatKcal(remaining)} tersisa',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: remaining == 0 ? diaryTerracotta : diaryGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: diaryLine,
            valueColor: const AlwaysStoppedAnimation(diaryGreen),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Asupan tercatat',
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
            Text(
              'Target ${dailyKcalTarget.round()} kcal',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        DiaryMacroBar(
          label: 'Protein',
          value: _totalProtein(),
          target: proteinTarget,
          color: diaryGreen,
        ),
        const SizedBox(height: 12),
        DiaryMacroBar(
          label: 'Lemak',
          value: _totalFat(),
          target: fatTarget,
          color: diaryOrange,
        ),
        const SizedBox(height: 12),
        DiaryMacroBar(
          label: 'Karbohidrat',
          value: _totalCarbs(),
          target: carbsTarget,
          color: diaryTerracotta,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _showNutritionDetails,
            icon: const Icon(Icons.insights_outlined, size: 16),
            label: const Text('Lihat ringkasan gizi'),
            style: TextButton.styleFrom(
              foregroundColor: diaryGreen,
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // ---------------------------------------------------------------------------
  // Section waktu makan (simple list view)
  // ---------------------------------------------------------------------------

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(19),
    border: Border.all(color: diaryLine.withOpacity(0.8)),
    boxShadow: [
      BoxShadow(
        color: diaryDarkGreen.withOpacity(0.035),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ],
  );

  List<Widget> _mealSections() => _meals.map(_buildMealSection).toList();

  Widget _buildMealHeader(String meal, num kcal) => Row(
    children: [
      Expanded(
        child: Text(
          meal,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: diaryDarkGreen,
          ),
        ),
      ),
      Text(
        '${kcal.round()} kkal',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: diaryGreen,
        ),
      ),
    ],
  );

  Widget _buildMealSection(String meal) {
    if (_addingMeal == meal) return _buildAddPanel(meal);

    final entries = _todayEntries.where((e) => e.meal == meal).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(meal, _mealKcal(meal)),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Belum ada makanan dicatat',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            )
          else
            for (int i = 0; i < entries.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: diaryLine),
              _buildEntryRow(entries[i]),
            ],
          const Divider(height: 1, color: diaryLine),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton.icon(
              onPressed: () => _startAdding(meal),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah makanan'),
              style: TextButton.styleFrom(
                foregroundColor: diaryGreen,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryRow(DiaryEntry entry) => InkWell(
    onTap: () => _showEditSheet(entry),
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: diaryDarkGreen,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${entry.grams.round()} g',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${entry.kcal.round()} kkal',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: diaryDarkGreen,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: diaryGreen, size: 22),
        ],
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  // Panel tambah makanan (inline)
  // ---------------------------------------------------------------------------

  Widget _buildAddPanel(String meal) {
    final foods = _visibleFoods;
    final count = _selected.length;
    final listHeight = foods.length > 4
        ? _foodRowHeight *
              3.5 // setengah baris terlihat = petunjuk bisa di-scroll
        : foods.length * _foodRowHeight;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealHeader(meal, _mealKcal(meal) + _pendingKcal),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Cari nasi, telur, buah....',
              hintStyle: const TextStyle(fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: diaryGreen),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Hapus pencarian',
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: diaryLine),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: diaryLine),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: diaryGreen, width: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            children: _filters
                .map(
                  (label) => ChoiceChip(
                    label: Text(label),
                    selected: _filter == label,
                    onSelected: (_) => setState(() => _filter = label),
                    selectedColor: diaryGreen,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: _filter == label ? Colors.white : diaryDarkGreen,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: _filter == label ? diaryGreen : diaryLine,
                    ),
                    showCheckmark: false,
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: diaryLine),
            ),
            clipBehavior: Clip.antiAlias,
            child: foods.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(18),
                    child: Center(
                      child: Text(
                        _emptyFoodMessage(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: listHeight,
                    child: Scrollbar(
                      controller: _foodListController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _foodListController,
                        itemExtent: _foodRowHeight,
                        itemCount: foods.length,
                        itemBuilder: (context, index) =>
                            _buildFoodRow(foods[index]),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            '$count dipilih, total ${_pendingKcal.round()} kkal',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: diaryDarkGreen,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 46,
                  child: TextButton(
                    onPressed: _cancelAdding,
                    style: TextButton.styleFrom(
                      foregroundColor: diaryDarkGreen,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 7,
                child: SizedBox(
                  height: 46,
                  child: FilledButton(
                    onPressed: count == 0 ? null : _saveSelected,
                    style: FilledButton.styleFrom(
                      backgroundColor: diaryGreen,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: diaryLine,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: Text(
                      count == 0 ? 'Simpan makanan' : 'Simpan $count makanan',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _emptyFoodMessage() {
    if (_query.trim().isNotEmpty) {
      return 'Makanan tidak ditemukan. Coba kata kunci lain.';
    }
    if (_filter == 'Favorit') {
      return 'Belum ada favorit. Ketuk ikon bintang di samping nama makanan untuk menandai favorit.';
    }
    if (_filter == 'Terakhir') {
      return 'Belum ada makanan terakhir.';
    }
    return 'Makanan tidak ditemukan.';
  }

  Widget _buildFoodRow(FoodItem food) {
    final grams = _selected[food.id] ?? 0;
    final selected = grams > 0;
    final isFavorite = _favoriteIds.contains(food.id);

    return Container(
      color: selected ? const Color(0xFFF1F6EE) : Colors.white,
      padding: const EdgeInsets.only(left: 12, right: 6),
      child: Row(
        children: [
          // Kolom kiri: title + kkal
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        food.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: diaryDarkGreen,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _toggleFavorite(food.id),
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isFavorite
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 18,
                          color: isFavorite ? diaryOrange : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${food.kcalPer100g.round()} kkal / 100 g',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          // Tombol kurangi
          IconButton(
            tooltip: 'Kurangi ${_portionStep.round()} g',
            onPressed: selected
                ? () => _setSelectedGrams(food.id, grams - _portionStep)
                : null,
            icon: const Icon(Icons.remove, size: 18),
            style: IconButton.styleFrom(
              foregroundColor: diaryGreen,
              disabledForegroundColor: Colors.black26,
              shape: CircleBorder(
                side: BorderSide(
                  color: selected ? diaryGreen : diaryLine,
                  width: 1.2,
                ),
              ),
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          // Nilai gram (ketuk untuk ketik manual)
          InkWell(
            onTap: () => _typeGrams(food),
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 58,
              height: 40,
              child: Center(
                child: Text(
                  '${grams.round()} g',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: selected ? diaryGreen : Colors.black45,
                  ),
                ),
              ),
            ),
          ),
          // Tombol tambah
          IconButton(
            tooltip: 'Tambah ${_portionStep.round()} g',
            onPressed: grams >= _maxGrams
                ? null
                : () => _setSelectedGrams(food.id, grams + _portionStep),
            icon: const Icon(Icons.add, size: 18),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: diaryGreen,
              disabledBackgroundColor: diaryLine,
              shape: const CircleBorder(),
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Catatan & ringkasan nutrisi
  // ---------------------------------------------------------------------------

  Widget _buildNutritionNote() => Container(
    margin: const EdgeInsets.only(top: 2, bottom: 8),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF0E5),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: diaryGreen, size: 18),
        SizedBox(width: 9),
        Expanded(
          child: Text(
            'Angka gizi adalah estimasi untuk membantu pencatatan, bukan pengukuran laboratorium. Resep, merek, minyak, dan ukuran porsi dapat mengubah hasil.',
            style: TextStyle(fontSize: 11, height: 1.45, color: diaryDarkGreen),
          ),
        ),
      ],
    ),
  );

  void _showNutritionDetails() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: diaryLine,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Ringkasan nutrisi',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: diaryDarkGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tanggal ${_prettyDate(_selectedDate)}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 18),
            _detailLine(
              'Energi',
              '${_totalKcal().round()} kcal',
              '${(dailyKcalTarget - _totalKcal()).round()} kcal dari target',
            ),
            _detailLine(
              'Protein',
              '${_totalProtein().toStringAsFixed(1)} g',
              'Target demo $proteinTarget g',
            ),
            _detailLine(
              'Lemak',
              '${_totalFat().toStringAsFixed(1)} g',
              'Target demo $fatTarget g',
            ),
            _detailLine(
              'Karbohidrat',
              '${_totalCarbs().toStringAsFixed(1)} g',
              'Target demo $carbsTarget g',
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailLine(String title, String value, String subtitle) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: diaryDarkGreen,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: diaryGreen,
          ),
        ),
      ],
    ),
  );
}

// =============================================================================
// Bottom sheet ubah porsi (dibuka dari ikon ">" pada list makanan)
// Mengembalikan: gram baru (>0) untuk simpan, -1 untuk hapus, null jika batal.
// =============================================================================

class _EditPortionSheet extends StatefulWidget {
  final DiaryEntry entry;
  final double step;
  final double maxGrams;

  const _EditPortionSheet({
    required this.entry,
    required this.step,
    required this.maxGrams,
  });

  @override
  State<_EditPortionSheet> createState() => _EditPortionSheetState();
}

class _EditPortionSheetState extends State<_EditPortionSheet> {
  late double _grams = widget.entry.grams.clamp(widget.step, widget.maxGrams);
  late final TextEditingController _controller = TextEditingController(
    text: _grams.round().toString(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setGrams(double value) {
    final safe = value.clamp(widget.step, widget.maxGrams).toDouble();
    setState(() {
      _grams = safe;
      _controller.text = safe.round().toString();
    });
  }

  void _save() {
    final parsed = double.tryParse(_controller.text.trim());
    if (parsed == null || parsed < widget.step || parsed > widget.maxGrams) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Masukkan jumlah porsi antara ${widget.step.round()}–${widget.maxGrams.round()} gram.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.pop(context, parsed);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final food = widget.entry.food;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: const BoxDecoration(
          color: diaryCream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: diaryLine,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ubah porsi',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          food.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: diaryDarkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Kurangi ${widget.step.round()} g',
                    onPressed: _grams <= widget.step
                        ? null
                        : () => _setGrams(_grams - widget.step),
                    icon: const Icon(Icons.remove, size: 20),
                    style: IconButton.styleFrom(
                      foregroundColor: diaryGreen,
                      disabledForegroundColor: Colors.black26,
                      shape: const CircleBorder(
                        side: BorderSide(color: diaryGreen, width: 1.2),
                      ),
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        final parsed = double.tryParse(value);
                        if (parsed != null &&
                            parsed >= widget.step &&
                            parsed <= widget.maxGrams) {
                          setState(() => _grams = parsed);
                        }
                      },
                      decoration: InputDecoration(
                        suffixText: 'g',
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: diaryLine),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: diaryLine),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    tooltip: 'Tambah ${widget.step.round()} g',
                    onPressed: _grams >= widget.maxGrams
                        ? null
                        : () => _setGrams(_grams + widget.step),
                    icon: const Icon(Icons.add, size: 20),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: diaryGreen,
                      disabledBackgroundColor: diaryLine,
                      shape: const CircleBorder(),
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_outlined,
                      color: diaryTerracotta,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${food.kcalPer100g.round()} kkal / 100 g',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Text(
                      '${food.kcalFor(_grams).round()} kkal',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: diaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 46,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, -1.0),
                        style: TextButton.styleFrom(
                          foregroundColor: diaryTerracotta,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: const Text('Hapus'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 7,
                    child: SizedBox(
                      height: 46,
                      child: FilledButton(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: diaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: const Text('Simpan perubahan'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
