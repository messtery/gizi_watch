import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/food_diary_widgets.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  static const double dailyKcalTarget = 2250;
  static const double proteinTarget = 80;
  static const double fatTarget = 65;
  static const double carbsTarget = 300;

  DateTime _selectedDate = DateTime.now();
  String _activeTab = 'Diary';
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
  Widget build(BuildContext context) {
    final consumed = _totalKcal();
    final remaining = math.max(0.0, dailyKcalTarget - consumed);
    final progress = (consumed / dailyKcalTarget).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: diaryCream,
      body: SafeArea(
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
                        12,
                        wide ? 28 : 16,
                        28,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildHeader(),
                          const SizedBox(height: 16),
                          _buildDatePicker(),
                          const SizedBox(height: 12),
                          _buildSummaryCard(consumed, remaining, progress),
                          const SizedBox(height: 20),
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
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() => Row(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: diaryGreen,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.eco_outlined, color: Colors.white, size: 24),
      ),
      const SizedBox(width: 11),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    ],
  );

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
    margin: const EdgeInsets.only(top: 2, bottom: 90),
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

  Widget _buildBottomNavigation() => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: diaryLine)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem('Home', Icons.home_outlined),
            _navItem('Diary', Icons.menu_book_outlined),
            _navItem('Body', Icons.monitor_weight_outlined),
            _navItem('Recipes', Icons.soup_kitchen_outlined),
            _navItem('News', Icons.newspaper_outlined),
          ],
        ),
      ),
    ),
  );

  Widget _navItem(String label, IconData icon) {
    final selected = _activeTab == label;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() => _activeTab = label);
        if (label != 'Diary') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$label akan dihubungkan ke halaman GiziWatch berikutnya.',
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: selected ? diaryGreen : Colors.black45),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? diaryGreen : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
  final TextEditingController _gramsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _category = 'Semua';
  bool _hasExpandedFood = false;

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
    _hasExpandedFood = widget.initialFood != null;
  }

  @override
  void dispose() {
    _gramsController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods => foodCatalog.where((food) {
    final matchesQuery = food.name.toLowerCase().contains(_query.toLowerCase());
    final matchesCategory = _category == 'Semua' || food.category == _category;
    return matchesQuery && matchesCategory;
  }).toList();

  void _setGrams(double value) {
    final safe = value.clamp(10, 1000).toDouble();
    setState(() {
      _grams = safe;
      _gramsController.text = safe.round().toString();
    });
  }

  void _selectFood(FoodItem food) {
    setState(() {
      if (_hasExpandedFood && _selectedFood.id == food.id) {
        _hasExpandedFood = false;
      } else {
        _selectedFood = food;
        _hasExpandedFood = true;
        _grams = 100;
        _gramsController.text = '100';
      }
    });
  }

  Widget _buildExpandedDetails() => Container(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
    decoration: const BoxDecoration(
      color: Color(0xFFEAF0E5),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Porsi makanan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: diaryDarkGreen,
                ),
              ),
            ),
            SizedBox(
              width: 88,
              child: TextField(
                controller: _gramsController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null && parsed >= 10 && parsed <= 1000) {
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
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${formatGram(_grams)} g • estimasi energi',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${_selectedFood.kcalFor(_grams).round()} kcal',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: diaryGreen,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Waktu makan',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: diaryDarkGreen,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedMeal,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: meals
                    .map(
                      (meal) => DropdownMenuItem(
                        value: meal,
                        child: Text(meal, style: const TextStyle(fontSize: 11)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedMeal = value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        SizedBox(
          width: double.infinity,
          height: 43,
          child: FilledButton.icon(
            onPressed: () {
              final parsed = double.tryParse(_gramsController.text);
              final grams = parsed != null && parsed >= 10 && parsed <= 1000
                  ? parsed
                  : _grams;
              widget.onSave(_selectedFood, grams, _selectedMeal);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: diaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.check, size: 18),
            label: Text(
              widget.initialFood == null
                  ? 'Simpan ke diary'
                  : 'Simpan perubahan',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final foods = _filteredFoods;

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
                padding: const EdgeInsets.fromLTRB(18, 14, 12, 10),
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
                            'Ketuk makanan untuk mengatur porsi dan menyimpan',
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
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Cari nasi, telur, buah...',
                    prefixIcon: const Icon(Icons.search, color: diaryGreen),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(color: diaryLine),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(color: diaryLine),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 47,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: categories
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _category == category,
                            onSelected: (_) =>
                                setState(() => _category = category),
                            selectedColor: diaryGreen,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 10,
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
                child: foods.isEmpty
                    ? const Center(
                        child: Text(
                          'Makanan tidak ditemukan. Coba kata kunci lain.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          final expanded =
                              _hasExpandedFood && food.id == _selectedFood.id;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: expanded ? diaryGreen : diaryLine,
                              ),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 2,
                                  ),
                                  onTap: () => _selectFood(food),
                                  leading: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: diaryCream,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      expanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.restaurant_outlined,
                                      color: diaryGreen,
                                      size: 21,
                                    ),
                                  ),
                                  title: Text(
                                    food.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: diaryDarkGreen,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${food.category} • ${food.kcalPer100g.round()} kcal / 100 g',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  trailing: Icon(
                                    expanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: expanded
                                        ? diaryGreen
                                        : Colors.black45,
                                  ),
                                ),
                                if (expanded) _buildExpandedDetails(),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
