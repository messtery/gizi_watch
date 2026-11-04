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

  DateTime _selectedDate = DateTime.now();
  int _nextEntryId = 10;

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

  void _saveEntry(
    FoodItem food,
    double grams,
    String meal, {
    String? editingId,
  }) {
    final list = List<DiaryEntry>.from(_todayEntries);
    if (editingId != null) {
      final index = list.indexWhere((e) => e.id == editingId);
      if (index >= 0)
        list[index] = DiaryEntry(
          id: editingId,
          food: food,
          grams: grams,
          meal: meal,
        );
    } else {
      list.add(
        DiaryEntry(
          id: 'e${_nextEntryId++}',
          food: food,
          grams: grams,
          meal: meal,
        ),
      );
    }
    setState(() => _entriesByDate[_dateKey(_selectedDate)] = list);
  }

  Future<void> _showFoodSheet({String? meal, DiaryEntry? editing}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddFoodSheet(
        initialMeal: editing?.meal ?? meal ?? 'Sarapan',
        initialFood: editing?.food,
        initialGrams: editing?.grams ?? 100,
        onSave: (food, grams, chosenMeal) {
          _saveEntry(food, grams, chosenMeal, editingId: editing?.id);
        },
      ),
    );
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
    if (confirmed == true) {
      setState(() {
        final list = List<DiaryEntry>.from(_todayEntries)
          ..removeWhere((e) => e.id == entry.id);
        _entriesByDate[_dateKey(_selectedDate)] = list;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.openAddFood) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showFoodSheet(meal: widget.initialMeal);
        }
      });
    }
  }

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
        elevation: 0,
        scrolledUnderElevation: 0,
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

  List<Widget> _mealSections() {
    const meals = ['Sarapan', 'Makan siang', 'Makan malam', 'Camilan'];
    return meals.map((meal) {
      final entries = _todayEntries.where((e) => e.meal == meal).toList();
      return DiarySectionCard(
        title: meal,
        kcal: _mealKcal(meal),
        entries: entries,
        onAdd: () => _showFoodSheet(meal: meal),
        onEdit: (entry) => _showFoodSheet(editing: entry),
        onDelete: _deleteEntry,
      );
    }).toList();
  }

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

class _AddFoodSheet extends StatefulWidget {
  final String initialMeal;
  final FoodItem? initialFood;
  final double initialGrams;
  final void Function(FoodItem food, double grams, String meal) onSave;

  const _AddFoodSheet({
    required this.initialMeal,
    required this.initialFood,
    required this.initialGrams,
    required this.onSave,
  });

  @override
  State<_AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<_AddFoodSheet> {
  late FoodItem _selectedFood = widget.initialFood ?? foodCatalog.first;
  late String _selectedMeal = widget.initialMeal;
  late double _grams = widget.initialGrams.clamp(10, 1000).toDouble();
  String? _expandedFoodId;
  String _query = '';
  String _category = 'Semua';
  final TextEditingController _gramsController = TextEditingController();

  static const categories = [
    'Semua',
    'Karbohidrat',
    'Protein',
    'Sayur',
    'Buah',
    'Susu',
    'Masakan',
    'Camilan',
  ];

  static const meals = ['Sarapan', 'Makan siang', 'Makan malam', 'Camilan'];

  @override
  void initState() {
    super.initState();
    _gramsController.text = _grams.round().toString();
    _expandedFoodId = widget.initialFood?.id;
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods {
    return foodCatalog.where((food) {
      final matchesQuery = food.name.toLowerCase().contains(
        _query.toLowerCase(),
      );
      final matchesCategory =
          _category == 'Semua' || food.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _setGrams(double value) {
    final safe = value.clamp(10, 1000).toDouble();
    setState(() {
      _grams = safe;
      _gramsController.text = safe.round().toString();
    });
  }

  void _toggleFood(FoodItem food) {
    setState(() {
      if (_expandedFoodId == food.id) {
        _expandedFoodId = null;
      } else {
        _expandedFoodId = food.id;
        _selectedFood = food;
      }
    });
  }

  Widget _buildFoodAccordion(FoodItem food) {
    final expanded = _expandedFoodId == food.id;
    final selected = _selectedFood.id == food.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expanded ? diaryGreen : diaryLine,
          width: expanded ? 1.4 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _toggleFood(food),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF0E5),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.restaurant_outlined,
                      color: diaryGreen,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: diaryDarkGreen,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${food.category} • ${food.kcalPer100g.round()} kcal / 100 g',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 7),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: diaryGreen,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: expanded
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(13, 2, 13, 13),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F7F1),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(13),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: diaryLine, height: 14),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Jumlah porsi',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: diaryDarkGreen,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 88,
                              child: TextField(
                                controller: _gramsController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: false,
                                    ),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed != null &&
                                      parsed >= 10 &&
                                      parsed <= 1000) {
                                    setState(() => _grams = parsed);
                                  }
                                },
                                decoration: InputDecoration(
                                  suffixText: 'g',
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                    borderSide: const BorderSide(
                                      color: diaryLine,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                    borderSide: const BorderSide(
                                      color: diaryLine,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _grams.clamp(10, 1000).toDouble(),
                          min: 10,
                          max: 1000,
                          divisions: 99,
                          activeColor: diaryGreen,
                          onChanged: _setGrams,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department_outlined,
                                color: diaryTerracotta,
                                size: 19,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${food.kcalPer100g.round()} kcal / 100 g',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Estimasi untuk ${formatGram(_grams)} g',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: diaryDarkGreen,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${food.kcalFor(_grams).round()} kcal',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: diaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 9),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() => _selectedFood = food);
                            },
                            icon: Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 16,
                            ),
                            label: Text(
                              selected
                                  ? 'Makanan dipilih'
                                  : 'Pilih makanan ini',
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: diaryGreen,
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: diaryCream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: diaryLine,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 15, 18, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.initialFood == null
                                ? 'Tambah makanan'
                                : 'Ubah catatan',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: diaryDarkGreen,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Pilih makanan untuk melihat detail dan porsinya',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Cari nasi, telur, buah...',
                    prefixIcon: const Icon(Icons.search, color: diaryGreen),
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
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: categories
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _category == category,
                            onSelected: (_) {
                              setState(() {
                                _category = category;
                                _expandedFoodId = null;
                              });
                            },
                            selectedColor: diaryGreen,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 11,
                              color: _category == category
                                  ? Colors.white
                                  : diaryDarkGreen,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(
                              color: _category == category
                                  ? diaryGreen
                                  : diaryLine,
                            ),
                            showCheckmark: false,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: _filteredFoods.isEmpty
                    ? const Center(
                        child: Text(
                          'Makanan tidak ditemukan. Coba kata kunci lain.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                        itemCount: _filteredFoods.length,
                        itemBuilder: (context, index) {
                          return _buildFoodAccordion(_filteredFoods[index]);
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: diaryLine)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Waktu makan',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: diaryDarkGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedMeal,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              filled: true,
                              fillColor: diaryCream,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: meals
                                .map(
                                  (meal) => DropdownMenuItem(
                                    value: meal,
                                    child: Text(
                                      meal,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedMeal = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          final parsed = double.tryParse(_gramsController.text);
                          final grams =
                              (parsed == null || parsed < 10 || parsed > 1000)
                              ? _grams
                              : parsed;
                          widget.onSave(_selectedFood, grams, _selectedMeal);
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: diaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.check),
                        label: Text(
                          widget.initialFood == null
                              ? 'Simpan ke diary'
                              : 'Simpan perubahan',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
