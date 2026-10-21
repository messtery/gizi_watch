
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/add_food.dart';

void main() {
  runApp(const GiziWatchApp());
}

class GiziWatchApp extends StatelessWidget {
  const GiziWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GiziWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F3E9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F6541),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        useMaterial3: true,
      ),
      home: AddFoodPage(
        selectedDate: DateTime.now(),
        initialMeal: 'Dinner',
        onAddFood: (
          food,
          meal,
          grams,
          nutrition,
          date,
        ) {
          debugPrint('Food: $food');
          debugPrint('Meal: $meal');
          debugPrint('Portion: $grams g');
          debugPrint('Nutrition: $nutrition');
          debugPrint('Date: $date');
        },
      ),
    );
  }
}
