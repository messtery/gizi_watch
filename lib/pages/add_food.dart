
import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

const Color forestGreen = Color(0xFF2F6541);
const Color darkGreen = Color(0xFF183C28);
const Color cream = Color(0xFFF6F3EC);
const Color softCream = Color(0xFFF0ECE1);
const Color borderColor = Color(0xFFE2DDD2);

const List<String> mealOptions = [
  'Breakfast',
  'Lunch',
  'Dinner',
  'Snacks',
];

const Map<String, Map<String, double>> foodDatabase = {
  'Tempe goreng': {
    'Energy': 350,
    'Protein': 20,
    'Fat': 28,
    'Carbs': 8,
    'Iron': 4,
    'Calcium': 120,
  },
  'Tempe kedelai murni': {
    'Energy': 193,
    'Protein': 20.3,
    'Fat': 10.8,
    'Carbs': 7.6,
    'Iron': 2.7,
    'Calcium': 111,
  },
  'Tempe bacem': {
    'Energy': 250,
    'Protein': 16,
    'Fat': 13,
    'Carbs': 18,
    'Iron': 2.5,
    'Calcium': 100,
  },
  'Tempe belacan': {
    'Energy': 280,
    'Protein': 17,
    'Fat': 18,
    'Carbs': 12,
    'Iron': 2.8,
    'Calcium': 105,
  },
  'Nasi putih': {
    'Energy': 130,
    'Protein': 2.7,
    'Fat': 0.3,
    'Carbs': 28.2,
    'Iron': 0.2,
    'Calcium': 10,
  },
  'Telur rebus': {
    'Energy': 155,
    'Protein': 12.6,
    'Fat': 10.6,
    'Carbs': 1.1,
    'Iron': 1.2,
    'Calcium': 50,
  },
  'Ayam panggang': {
    'Energy': 190,
    'Protein': 28,
    'Fat': 8,
    'Carbs': 0,
    'Iron': 1.3,
    'Calcium': 15,
  },
  'Pisang': {
    'Energy': 89,
    'Protein': 1.1,
    'Fat': 0.3,
    'Carbs': 22.8,
    'Iron': 0.3,
    'Calcium': 5,
  },
};

class AddFoodPage extends StatefulWidget {
  final DateTime? selectedDate;
  final String? initialMeal;

  // Callback untuk integrasi dengan Food Diary nanti.
  final void Function(
    String food,
    String meal,
    int grams,
    Map<String, double> nutrition,
    DateTime date,
  )? onAddFood;

  const AddFoodPage({
    super.key,
    this.selectedDate,
    this.initialMeal,
    this.onAddFood,
  });

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  late DateTime selectedDate;
  late String selectedMeal;

  String selectedFood = 'Tempe goreng';
  int portion = 40;

  bool showSuggestions = false;
  final TextEditingController searchController =
      TextEditingController();

  List<String> get filteredFoods {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return foodDatabase.keys.toList();
    }

    return foodDatabase.keys
        .where((food) => food.toLowerCase().contains(query))
        .toList();
  }

  Map<String, double> get calculatedNutrition {
    final base = foodDatabase[selectedFood]!;
    return base.map(
      (key, value) => MapEntry(key, value * portion / 100),
    );
  }

  @override
  void initState() {
    super.initState();

    selectedDate = widget.selectedDate ?? DateTime.now();

    selectedMeal = mealOptions.contains(widget.initialMeal)
        ? widget.initialMeal!
        : 'Dinner';

    searchController.text = selectedFood;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${selectedDate.day} ${months[selectedDate.month - 1]}';
  }

  void selectFood(String food) {
    setState(() {
      selectedFood = food;
      searchController.text = food;
      showSuggestions = false;
    });
  }

  void updatePortion(String value) {
    final parsed = int.tryParse(value);

    if (parsed != null && parsed >= 1 && parsed <= 10000) {
      setState(() => portion = parsed);
    }
  }

  void changePortion(int amount) {
    setState(() {
      portion = (portion + amount).clamp(1, 10000);
    });
  }

  String formatNumber(double value) {
    return value.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  }

  void addFood() {
    widget.onAddFood?.call(
      selectedFood,
      selectedMeal,
      portion,
      calculatedNutrition,
      selectedDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$selectedFood ditambahkan ke $selectedMeal'),
        backgroundColor: forestGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 18),

                    _buildLabel('Meal'),
                    const SizedBox(height: 8),
                    _buildMealSelector(),

                    const SizedBox(height: 20),

                    _buildLabel('Food'),
                    const SizedBox(height: 8),
                    _buildFoodSearch(),

                    const SizedBox(height: 20),

                    _buildLabel('Portion'),
                    const SizedBox(height: 8),
                    _buildPortionSelector(),

                    const SizedBox(height: 16),

                    _buildNutritionCard(),
                  ],
                ),
              ),
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: darkGreen,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Food',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 24,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Today, $formattedDate',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777269),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: darkGreen,
      ),
    );
  }

  Widget _buildMealSelector() {
    return Row(
      children: mealOptions.map((meal) {
        final selected = selectedMeal == meal;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Material(
              color: selected ? forestGreen : Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => selectedMeal = meal),
                child: Container(
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? forestGreen : borderColor,
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      meal,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFoodSearch() {
    return Column(
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: showSuggestions ? forestGreen : borderColor,
              width: showSuggestions ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onTap: () => setState(() => showSuggestions = true),
                  onChanged: (_) => setState(() => showSuggestions = true),
                  style: const TextStyle(
                    fontSize: 14,
                    color: darkGreen,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(
                  () => showSuggestions = !showSuggestions,
                ),
                icon: Icon(
                  showSuggestions
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: darkGreen,
                ),
              ),
            ],
          ),
        ),

        if (showSuggestions) ...[
          const SizedBox(height: 7),
          Container(
            constraints: const BoxConstraints(maxHeight: 230),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: softCream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.search,
                          size: 17,
                          color: Color(0xFF777269),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchBoxController,
                            onChanged: (value) {
                              searchController.text = value;
                              searchController.selection =
                                  TextSelection.collapsed(
                                offset: value.length,
                              );
                              setState(() {});
                            },
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: 'Search food...',
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: filteredFoods.isEmpty
                      ? const Center(
                          child: Text(
                            'No food found',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 5),
                          shrinkWrap: true,
                          itemCount: filteredFoods.length,
                          itemBuilder: (context, index) {
                            final food = filteredFoods[index];
                            final selected = food == selectedFood;

                            return InkWell(
                              onTap: () {
                                _searchBoxController.clear();
                                selectFood(food);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFDCEBDD)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        food,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      const Icon(
                                        Icons.check,
                                        size: 18,
                                        color: forestGreen,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  final TextEditingController _searchBoxController =
      TextEditingController();

  Widget _buildPortionSelector() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: portion > 1 ? () => changePortion(-1) : null,
            icon: const Icon(Icons.remove, size: 19),
            color: darkGreen,
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: TextField(
              key: ValueKey(portion),
              controller: TextEditingController(text: '$portion'),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: darkGreen,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: updatePortion,
            ),
          ),
          const Text(
            'g',
            style: TextStyle(fontSize: 14, color: darkGreen),
          ),
          const SizedBox(width: 32),
          IconButton(
            onPressed: () => changePortion(1),
            icon: const Icon(Icons.add, size: 19),
            color: darkGreen,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    final nutrition = calculatedNutrition;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$selectedFood · $portion g',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 7,
            crossAxisSpacing: 7,
            childAspectRatio: 1.9,
            children: [
              _nutritionItem(
                'Energy',
                '${formatNumber(nutrition['Energy']!)} kcal',
              ),
              _nutritionItem(
                'Protein',
                '${formatNumber(nutrition['Protein']!)} g',
              ),
              _nutritionItem(
                'Fat',
                '${formatNumber(nutrition['Fat']!)} g',
              ),
              _nutritionItem(
                'Carbs',
                '${formatNumber(nutrition['Carbs']!)} g',
              ),
              _nutritionItem(
                'Iron',
                '${formatNumber(nutrition['Iron']!)} mg',
              ),
              _nutritionItem(
                'Calcium',
                '${formatNumber(nutrition['Calcium']!)} mg',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nutritionItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: softCream,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF777269),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: cream,
        border: Border(
          top: BorderSide(color: Color(0xFFE8E2D8)),
        ),
      ),
      child: PrimaryButton(
        text: 'Add to ${selectedMeal.toLowerCase()}',
        onPressed: addFood,
      ),
    );
  }
}
