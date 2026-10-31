import 'package:flutter/material.dart';
const Color cream = Color(0xFFF6F3EC);
const Color green = Color(0xFF2F6541);
const Color darkGreen = Color(0xFF183C28);
const Color softGreen = Color(0xFFE5EDE5);
const Color beige = Color(0xFFE8E1D2);
const Color textDark = Color(0xFF26352A);
const Color textGrey = Color(0xFF858B84);
class BodyPage extends StatefulWidget {
  const BodyPage({super.key});
  @override
  State<BodyPage> createState() => _BodyPageState();
}
class _BodyPageState extends State<BodyPage> {
  List<Measurement> measurements = [];
  bool isLoading = true;
  int selectedNavIndex = 2; // Body menjadi tab yang pertama kali dibuka.
  Measurement? get latestMeasurement {
    if (measurements.isEmpty) return null;
    return measurements.first;
  }
  @override
  void initState() {
    super.initState();
    loadMeasurements();
  }
  // Data pengukuran disimpan sementara selama aplikasi berjalan.
  // Tidak membutuhkan package tambahan atau perubahan pubspec.yaml.
  Future<void> loadMeasurements() async {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> saveMeasurements() async {
    // Tidak ada penyimpanan permanen pada versi tanpa dependency.
    // List measurements tetap digunakan selama aplikasi berjalan.
  }
  Future<void> openMeasurementForm({
    Measurement? measurement,
  }) async {
    final result = await Navigator.push<Measurement>(
      context,
      MaterialPageRoute(
        builder: (_) => MeasurementFormPage(
          measurement: measurement,
        ),
      ),
    );
    if (result == null) return;
    setState(() {
      measurements.removeWhere(
        (item) => item.id == result.id,
      );
      measurements.add(result);
      measurements.sort(
        (a, b) => b.date.compareTo(a.date),
      );
    });
    await saveMeasurements();
  }
  Future<void> deleteMeasurement(Measurement item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Measurement?'),
        content: const Text(
          'Are you sure you want to delete this measurement?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              color: textGrey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        measurements.removeWhere(
          (measurement) => measurement.id == item.id,
        );
      });
      await saveMeasurements();
    }
  }
  String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
  String getCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
  Color getCategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.orange;
    if (bmi < 25) return green;
    if (bmi < 30) return Colors.deepOrange;
    return Colors.redAccent;
  }
  double getHealthyWeightMin(double height) {
    final heightMeter = height / 100;
    return 18.5 * heightMeter * heightMeter;
  }
  double getHealthyWeightMax(double height) {
    final heightMeter = height / 100;
    return 24.9 * heightMeter * heightMeter;
  }
  double getWeightChange() {
    if (measurements.length < 2) return 0;
    return measurements[0].weight - measurements[1].weight;
  }
  @override
  Widget build(BuildContext context) {
    final isBodyTab = selectedNavIndex == 2;

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: green),
              )
            : isBodyTab
                ? CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _buildHeader(),
                            const SizedBox(height: 22),
                            _buildBmiCard(),
                            const SizedBox(height: 22),
                            _buildProgressSection(),
                            const SizedBox(height: 22),
                            _buildHistorySection(),
                          ]),
                        ),
                      ),
                    ],
                  )
                : _buildComingSoonPage(),
      ),
      floatingActionButton: isBodyTab
          ? FloatingActionButton.extended(
              onPressed: () => openMeasurementForm(),
              backgroundColor: green,
              foregroundColor: Colors.white,
              elevation: 3,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Measurement',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    const items = [
      _NavigationItem(label: 'Home', icon: Icons.home_outlined),
      _NavigationItem(label: 'Diary', icon: Icons.menu_book_outlined),
      _NavigationItem(label: 'Body', icon: Icons.monitor_weight_outlined),
      _NavigationItem(label: 'Recipes', icon: Icons.restaurant_menu_outlined),
      _NavigationItem(label: 'News', icon: Icons.newspaper_outlined),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: beige.withValues(alpha: 0.8), width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = selectedNavIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedNavIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 25,
                        color: isSelected ? green : textGrey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 10.5,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? green : textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildComingSoonPage() {
    const titles = ['Home', 'Diary', '', 'Recipes', 'News'];
    final title = titles[selectedNavIndex];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selectedNavIndex == 0
                  ? Icons.home_outlined
                  : selectedNavIndex == 1
                      ? Icons.menu_book_outlined
                      : selectedNavIndex == 3
                          ? Icons.restaurant_menu_outlined
                          : Icons.newspaper_outlined,
              color: green,
              size: 48,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This page will be available soon.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 13,
                color: textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weight & BMI',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 29,
letterSpacing: -0.8,
            height: 1.05,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track your body progress and stay healthy.',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
  Widget _buildBmiCard() {
    final item = latestMeasurement;
    if (item == null) {
      return _emptyCard(
        icon: Icons.monitor_weight_outlined,
        title: 'No measurements yet',
        description:
            'Add your first measurement to see your BMI information.',
      );
    }
    final bmi = item.bmi;
    final category = getCategory(bmi);
    final categoryColor = getCategoryColor(bmi);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Your BMI',
                  style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
                    color: cream,
                    fontSize: 14,
),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Last measured',
                    style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              color: cream, fontSize: 10),
                  ),
                  Text(
                    formatDate(item.date),
                    style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                      color: cream,
                      fontSize: 11,
),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                bmi.toStringAsFixed(1),
                style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                  color: cream,
                  fontSize: 42,
                  height: 1.0,
letterSpacing: -1.2,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                    color: categoryColor,
                    fontSize: 11,
),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBmiScale(bmi, darkMode: true),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _measurementInfoTile(
                  'Weight', '${item.weight.toStringAsFixed(1)} kg'),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _measurementInfoTile(
                  'Height', '${item.height.toStringAsFixed(1)} cm'),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Text(
            'Healthy weight range: '
            '${getHealthyWeightMin(item.height).toStringAsFixed(1)} - '
            '${getHealthyWeightMax(item.height).toStringAsFixed(1)} kg',
            style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 11, color: cream),
          ),
        ],
      ),
    );
  }
  Widget _measurementInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF294B36),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              color: cream, fontSize: 11)),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              color: cream,
              fontSize: 15,
),
          ),
        ],
      ),
    );
  }
  Widget _buildBmiScale(double bmi, {bool darkMode = false}) {
    final position = ((bmi - 15) / 25).clamp(0.0, 1.0);
    return Column(
      children: [
        SizedBox(
          height: 18,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      _scaleSegment(const Color(0xFFE7B45B)),
                      _scaleSegment(const Color(0xFF70A77A)),
                      _scaleSegment(const Color(0xFFE6A45D)),
                      _scaleSegment(const Color(0xFFD9786D)),
                    ],
                  ),
                  Positioned(
                    left: (constraints.maxWidth - 16) * position,
                    top: -4,
                    child: Container(
                      width: 16,
                      height: 26,
                      decoration: BoxDecoration(
                        color: darkMode ? cream : darkGreen,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Underweight',
                style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 9, color: darkMode ? cream : textGrey)),
            Text('Normal',
                style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 9, color: darkMode ? cream : textGrey)),
            Text('Overweight',
                style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 9, color: darkMode ? cream : textGrey)),
            Text('Obese',
                style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 9, color: darkMode ? cream : textGrey)),
          ],
        ),
      ],
    );
  }
  Widget _scaleSegment(Color color) {
    return Expanded(
      child: Container(
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  Widget _infoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: green, size: 21),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                color: textGrey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                color: darkGreen,
                fontSize: 15,
),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildProgressSection() {
    final change = getWeightChange();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weight Progress',
            style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 17,
color: darkGreen,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your weight development over time',
            style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 12,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 18),
          if (measurements.length >= 2)
            Row(
              children: [
                Icon(
                  change > 0
                      ? Icons.trending_up
                      : change < 0
                          ? Icons.trending_down
                          : Icons.trending_flat,
                  color: green,
                  size: 19,
                ),
                const SizedBox(width: 6),
                Text(
                  '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                  style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                    color: green,
fontSize: 14,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'vs previous measurement',
                  style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          if (measurements.length >= 2)
            SizedBox(
              height: 190,
              width: double.infinity,
              child: CustomPaint(
                painter: WeightChartPainter(
                  measurements: measurements.reversed.toList(),
                ),
              ),
            )
          else
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Add at least two measurements to view your weight progress chart.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: green,
                size: 9,
              ),
              const SizedBox(width: 6),
              const Text(
                'Weight (kg)',
                style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: textGrey,
                ),
              ),
              const Spacer(),
              Text(
                '${measurements.length} measurements',
                style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Measurement History',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 17,
color: darkGreen,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Review your previous measurements',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: textGrey,
          ),
        ),
        const SizedBox(height: 14),
        if (measurements.isEmpty)
          _emptyCard(
            icon: Icons.history,
            title: 'No history available',
            description: 'Your saved measurements will appear here.',
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final item = measurements[index];
              return _historyCard(item);
            },
          ),
      ],
    );
  }
  Widget _historyCard(Measurement item) {
    final bmi = item.bmi;
    final category = getCategory(bmi);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDate(item.date),
                  style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                    color: darkGreen,
                    fontSize: 13,
),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.weight.toStringAsFixed(1)} kg  •  '
                  '${item.height.toStringAsFixed(1)} cm',
                  style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                    color: textGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bmi.toStringAsFixed(1),
                style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                  color: darkGreen,
                  fontSize: 16,
),
              ),
              Text(
                category,
                style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                  color: getCategoryColor(bmi),
                  fontSize: 10,
),
              ),
            ],
          ),
          const SizedBox(width: 2),
          PopupMenuButton<String>(
            tooltip: 'More options',
            icon: const Icon(
              Icons.more_vert,
              color: textGrey,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40),
            onSelected: (value) {
              if (value == 'edit') {
                openMeasurementForm(measurement: item);
              } else if (value == 'delete') {
                deleteMeasurement(item);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: green),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _emptyCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: green, size: 38),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              color: darkGreen,
fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
class _NavigationItem {
  final String label;
  final IconData icon;

  const _NavigationItem({required this.label, required this.icon});
}

// --------------------------------------------------
// MEASUREMENT MODEL
// --------------------------------------------------
class Measurement {
  final String id;
  final DateTime date;
  final double weight;
  final double height;
  final String notes;
  Measurement({
    required this.id,
    required this.date,
    required this.weight,
    required this.height,
    this.notes = '',
  });
  double get bmi {
    final heightMeter = height / 100;
    return weight / (heightMeter * heightMeter);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'height': height,
      'notes': notes,
    };
  }
  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'],
      date: DateTime.parse(json['date']),
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      notes: json['notes'] ?? '',
    );
  }
}
// --------------------------------------------------
// ADD / EDIT MEASUREMENT FORM
// --------------------------------------------------
class MeasurementFormPage extends StatefulWidget {
  final Measurement? measurement;
  const MeasurementFormPage({
    super.key,
    this.measurement,
  });
  @override
  State<MeasurementFormPage> createState() =>
      _MeasurementFormPageState();
}
class _MeasurementFormPageState extends State<MeasurementFormPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController notesController;
  late DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    final item = widget.measurement;
    weightController = TextEditingController(
      text: item?.weight.toString() ?? '',
    );
    heightController = TextEditingController(
      text: item?.height.toString() ?? '',
    );
    notesController = TextEditingController(
      text: item?.notes ?? '',
    );
    selectedDate = item?.date ?? DateTime.now();
    weightController.addListener(updatePreview);
    heightController.addListener(updatePreview);
  }
  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    notesController.dispose();
    super.dispose();
  }
  void updatePreview() {
    if (mounted) setState(() {});
  }
  double? get calculatedBmi {
    final weight = double.tryParse(weightController.text);
    final height = double.tryParse(heightController.text);
    if (weight == null || height == null ||
        weight <= 0 || height <= 0) {
      return null;
    }
    final heightMeter = height / 100;
    return weight / (heightMeter * heightMeter);
  }
  String getCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
  String formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: darkGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  void saveMeasurement() {
    if (!formKey.currentState!.validate()) return;
    final weight = double.parse(weightController.text);
    final height = double.parse(heightController.text);
    final result = Measurement(
      id: widget.measurement?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      date: selectedDate,
      weight: weight,
      height: height,
      notes: notesController.text.trim(),
    );
    Navigator.pop(context, result);
  }
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          color: darkGreen,
          fontSize: 13,
),
      ),
    );
  }
  InputDecoration inputDecoration(String hint, String suffix) {
    return InputDecoration(
      hintText: hint,
      suffixText: suffix,
      filled: true,
      fillColor: cream,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: green,
          width: 1.3,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final bmi = calculatedBmi;
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        foregroundColor: darkGreen,
        title: Text(
          widget.measurement == null
              ? 'Add Measurement'
              : 'Edit Measurement',
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 19,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
            children: [
              const Text(
                'Record your body measurements',
                style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                  color: textGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 22),
              buildLabel('Measurement Date'),
              InkWell(
                onTap: pickDate,
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          formatDate(selectedDate),
                          style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                            color: darkGreen,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: textGrey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildLabel('Weight'),
              TextFormField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: inputDecoration('Enter weight', 'kg'),
                validator: (value) {
                  final number = double.tryParse(value ?? '');
                  if (number == null) {
                    return 'Please enter a valid weight.';
                  }
                  if (number < 2 || number > 500) {
                    return 'Weight must be between 2 and 500 kg.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              buildLabel('Height'),
              TextFormField(
                controller: heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: inputDecoration('Enter height', 'cm'),
                validator: (value) {
                  final number = double.tryParse(value ?? '');
                  if (number == null) {
                    return 'Please enter a valid height.';
                  }
                  if (number < 50 || number > 250) {
                    return 'Height must be between 50 and 250 cm.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (bmi != null) ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: softGreen,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calculate_outlined,
                        color: green,
                        size: 30,
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Calculated BMI',
                              style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                                color: textGrey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${bmi.toStringAsFixed(1)}  •  ${getCategory(bmi)}',
                              style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
                                color: darkGreen,
                                fontSize: 17,
),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              buildLabel('Notes (Optional)'),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add notes about your measurement...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: saveMeasurement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    widget.measurement == null
                        ? 'Save Measurement'
                        : 'Update Measurement',
                    style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
              fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// --------------------------------------------------
// WEIGHT PROGRESS CHART
// --------------------------------------------------
class WeightChartPainter extends CustomPainter {
  final List<Measurement> measurements;
  WeightChartPainter({
    required this.measurements,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (measurements.length < 2) return;
    const leftPadding = 38.0;
    const rightPadding = 12.0;
    const topPadding = 18.0;
    const bottomPadding = 25.0;
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;
    final weights = measurements.map((e) => e.weight).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final range = (maxWeight - minWeight);
    final padding = range == 0 ? 2.0 : range * 0.25;
    final minY = minWeight - padding;
    final maxY = maxWeight + padding;
    final totalRange = maxY - minY;
    double getX(int index) {
      return leftPadding +
          (index / (measurements.length - 1)) * chartWidth;
    }
    double getY(double weight) {
      return topPadding +
          chartHeight -
          ((weight - minY) / totalRange) * chartHeight;
    }
    final gridPaint = Paint()
      ..color = beige
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final y = topPadding + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
    }
    final linePath = Path();
    for (int i = 0; i < measurements.length; i++) {
      final point = Offset(
        getX(i),
        getY(measurements[i].weight),
      );
      if (i == 0) {
        linePath.moveTo(point.dx, point.dy);
      } else {
        linePath.lineTo(point.dx, point.dy);
      }
    }
    final fillPath = Path.from(linePath)
      ..lineTo(getX(measurements.length - 1),
          topPadding + chartHeight)
      ..lineTo(getX(0), topPadding + chartHeight)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          green.withValues(alpha: 0.20),
          green.withValues(alpha: 0.01),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(
          leftPadding,
          topPadding,
          chartWidth,
          chartHeight,
        ),
      )
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);
    final linePaint = Paint()
      ..color = green
      ..strokeWidth = 2.7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);
    for (int i = 0; i < measurements.length; i++) {
      final x = getX(i);
      final y = getY(measurements[i].weight);
      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        Offset(x, y),
        3.5,
        Paint()..color = green,
      );
      final valuePainter = TextPainter(
        text: TextSpan(
          text: measurements[i].weight.toStringAsFixed(1),
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: darkGreen,
            fontSize: 9,
),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      valuePainter.paint(
        canvas,
        Offset(
          x - valuePainter.width / 2,
          y - 17,
        ),
      );
    }
    final labels = [
      measurements.first.date,
      measurements[measurements.length ~/ 2].date,
      measurements.last.date,
    ];
    final labelIndexes = [
      0,
      measurements.length ~/ 2,
      measurements.length - 1,
    ];
    for (int i = 0; i < labels.length; i++) {
      final date = labels[i];
      final label = '${date.day}/${date.month}';
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: textGrey,
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = getX(labelIndexes[i]);
      painter.paint(
        canvas,
        Offset(
          x - painter.width / 2,
          size.height - 17,
        ),
      );
    }
  }
  @override
  bool shouldRepaint(covariant WeightChartPainter oldDelegate) {
    return oldDelegate.measurements != measurements;
  }
}
