import 'package:flutter/material.dart';

const Color diaryCream = Color(0xFFF7F3E9);
const Color diaryGreen = Color(0xFF2F6541);
const Color diaryDarkGreen = Color(0xFF183C28);
const Color diaryOrange = Color(0xFFF0B65E);
const Color diaryTerracotta = Color(0xFFC86F47);
const Color diarySage = Color(0xFF76A783);
const Color diaryLine = Color(0xFFE6E0D1);

class FoodItem {
  final String id;
  final String name;
  final String category;
  final double kcalPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;
  final String note;

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
    this.note = 'Estimasi per 100 g',
  });

  double kcalFor(double grams) => kcalPer100g * grams / 100;
  double proteinFor(double grams) => proteinPer100g * grams / 100;
  double fatFor(double grams) => fatPer100g * grams / 100;
  double carbsFor(double grams) => carbsPer100g * grams / 100;
}

class DiaryEntry {
  final String id;
  final FoodItem food;
  final double grams;
  final String meal;

  const DiaryEntry({
    required this.id,
    required this.food,
    required this.grams,
    required this.meal,
  });

  double get kcal => food.kcalFor(grams);
  double get protein => food.proteinFor(grams);
  double get fat => food.fatFor(grams);
  double get carbs => food.carbsFor(grams);

  DiaryEntry copyWith({double? grams, String? meal}) => DiaryEntry(
    id: id,
    food: food,
    grams: grams ?? this.grams,
    meal: meal ?? this.meal,
  );
}

/// Nilai perkiraan per 100 g bagian yang dapat dimakan.
/// Makanan goreng/masakan campuran bervariasi menurut resep dan minyak.
const double porridgeKcal = 35;
const List<FoodItem> foodCatalog = [
  FoodItem(
    id: 'f01',
    name: 'Nasi putih matang',
    category: 'Karbohidrat',
    kcalPer100g: 180,
    proteinPer100g: 3.0,
    fatPer100g: 0.3,
    carbsPer100g: 39.8,
  ),
  FoodItem(
    id: 'f02',
    name: 'Nasi merah matang',
    category: 'Karbohidrat',
    kcalPer100g: 149,
    proteinPer100g: 2.8,
    fatPer100g: 0.5,
    carbsPer100g: 32.5,
  ),
  FoodItem(
    id: 'f03',
    name: 'Bubur nasi polos',
    category: 'Karbohidrat',
    kcalPer100g: porridgeKcal,
    proteinPer100g: 1.1,
    fatPer100g: 0.2,
    carbsPer100g: 7.5,
  ),
  FoodItem(
    id: 'f04',
    name: 'Kentang rebus',
    category: 'Karbohidrat',
    kcalPer100g: 87,
    proteinPer100g: 1.9,
    fatPer100g: 0.1,
    carbsPer100g: 20.1,
  ),
  FoodItem(
    id: 'f05',
    name: 'Ubi jalar kukus',
    category: 'Karbohidrat',
    kcalPer100g: 90,
    proteinPer100g: 2.0,
    fatPer100g: 0.2,
    carbsPer100g: 20.7,
  ),
  FoodItem(
    id: 'f06',
    name: 'Oatmeal matang',
    category: 'Karbohidrat',
    kcalPer100g: 71,
    proteinPer100g: 2.5,
    fatPer100g: 1.5,
    carbsPer100g: 12.0,
  ),
  FoodItem(
    id: 'f07',
    name: 'Roti tawar',
    category: 'Karbohidrat',
    kcalPer100g: 265,
    proteinPer100g: 8.9,
    fatPer100g: 3.2,
    carbsPer100g: 49.0,
  ),
  FoodItem(
    id: 'f08',
    name: 'Mi telur matang',
    category: 'Karbohidrat',
    kcalPer100g: 138,
    proteinPer100g: 4.5,
    fatPer100g: 2.1,
    carbsPer100g: 25.0,
  ),
  FoodItem(
    id: 'f09',
    name: 'Jagung rebus',
    category: 'Karbohidrat',
    kcalPer100g: 96,
    proteinPer100g: 3.4,
    fatPer100g: 1.5,
    carbsPer100g: 21.0,
  ),
  FoodItem(
    id: 'f10',
    name: 'Singkong rebus',
    category: 'Karbohidrat',
    kcalPer100g: 160,
    proteinPer100g: 1.4,
    fatPer100g: 0.3,
    carbsPer100g: 38.0,
  ),
  FoodItem(
    id: 'f11',
    name: 'Telur ayam rebus',
    category: 'Protein',
    kcalPer100g: 155,
    proteinPer100g: 12.6,
    fatPer100g: 10.6,
    carbsPer100g: 1.1,
  ),
  FoodItem(
    id: 'f12',
    name: 'Telur dadar',
    category: 'Protein',
    kcalPer100g: 190,
    proteinPer100g: 11.0,
    fatPer100g: 15.0,
    carbsPer100g: 1.5,
    note: 'Bervariasi menurut minyak',
  ),
  FoodItem(
    id: 'f13',
    name: 'Dada ayam panggang',
    category: 'Protein',
    kcalPer100g: 165,
    proteinPer100g: 31.0,
    fatPer100g: 3.6,
    carbsPer100g: 0.0,
  ),
  FoodItem(
    id: 'f14',
    name: 'Ayam goreng',
    category: 'Protein',
    kcalPer100g: 260,
    proteinPer100g: 25.0,
    fatPer100g: 17.0,
    carbsPer100g: 5.0,
    note: 'Estimasi, tergantung kulit dan tepung',
  ),
  FoodItem(
    id: 'f15',
    name: 'Ikan kembung panggang',
    category: 'Protein',
    kcalPer100g: 167,
    proteinPer100g: 20.0,
    fatPer100g: 9.0,
    carbsPer100g: 0.0,
  ),
  FoodItem(
    id: 'f16',
    name: 'Ikan lele goreng',
    category: 'Protein',
    kcalPer100g: 240,
    proteinPer100g: 18.0,
    fatPer100g: 18.0,
    carbsPer100g: 2.0,
    note: 'Bervariasi menurut minyak',
  ),
  FoodItem(
    id: 'f17',
    name: 'Ikan tuna matang',
    category: 'Protein',
    kcalPer100g: 132,
    proteinPer100g: 29.0,
    fatPer100g: 0.6,
    carbsPer100g: 0.0,
  ),
  FoodItem(
    id: 'f18',
    name: 'Daging sapi tanpa lemak matang',
    category: 'Protein',
    kcalPer100g: 217,
    proteinPer100g: 26.0,
    fatPer100g: 12.0,
    carbsPer100g: 0.0,
  ),
  FoodItem(
    id: 'f19',
    name: 'Tahu putih',
    category: 'Protein',
    kcalPer100g: 80,
    proteinPer100g: 8.1,
    fatPer100g: 4.8,
    carbsPer100g: 1.9,
  ),
  FoodItem(
    id: 'f20',
    name: 'Tahu goreng',
    category: 'Protein',
    kcalPer100g: 115,
    proteinPer100g: 9.7,
    fatPer100g: 8.5,
    carbsPer100g: 2.5,
  ),
  FoodItem(
    id: 'f21',
    name: 'Tempe mentah',
    category: 'Protein',
    kcalPer100g: 150,
    proteinPer100g: 14.0,
    fatPer100g: 7.7,
    carbsPer100g: 9.1,
  ),
  FoodItem(
    id: 'f22',
    name: 'Tempe goreng',
    category: 'Protein',
    kcalPer100g: 350,
    proteinPer100g: 24.5,
    fatPer100g: 26.6,
    carbsPer100g: 10.4,
    note: 'Nilai TKPI dapat bervariasi menurut penyerapan minyak',
  ),
  FoodItem(
    id: 'f23',
    name: 'Kacang merah rebus',
    category: 'Protein',
    kcalPer100g: 127,
    proteinPer100g: 8.7,
    fatPer100g: 0.5,
    carbsPer100g: 22.8,
  ),
  FoodItem(
    id: 'f24',
    name: 'Susu sapi rendah lemak',
    category: 'Susu',
    kcalPer100g: 50,
    proteinPer100g: 3.4,
    fatPer100g: 1.5,
    carbsPer100g: 5.0,
  ),
  FoodItem(
    id: 'f25',
    name: 'Yogurt tawar',
    category: 'Susu',
    kcalPer100g: 61,
    proteinPer100g: 3.5,
    fatPer100g: 3.3,
    carbsPer100g: 4.7,
  ),
  FoodItem(
    id: 'f26',
    name: 'Keju cheddar',
    category: 'Susu',
    kcalPer100g: 403,
    proteinPer100g: 24.9,
    fatPer100g: 33.1,
    carbsPer100g: 1.3,
  ),
  FoodItem(
    id: 'f27',
    name: 'Bayam rebus',
    category: 'Sayur',
    kcalPer100g: 23,
    proteinPer100g: 3.0,
    fatPer100g: 0.3,
    carbsPer100g: 3.8,
  ),
  FoodItem(
    id: 'f28',
    name: 'Kangkung rebus',
    category: 'Sayur',
    kcalPer100g: 20,
    proteinPer100g: 2.1,
    fatPer100g: 0.2,
    carbsPer100g: 3.1,
  ),
  FoodItem(
    id: 'f29',
    name: 'Brokoli kukus',
    category: 'Sayur',
    kcalPer100g: 35,
    proteinPer100g: 2.4,
    fatPer100g: 0.4,
    carbsPer100g: 7.2,
  ),
  FoodItem(
    id: 'f30',
    name: 'Wortel rebus',
    category: 'Sayur',
    kcalPer100g: 35,
    proteinPer100g: 0.8,
    fatPer100g: 0.2,
    carbsPer100g: 8.2,
  ),
  FoodItem(
    id: 'f31',
    name: 'Timun segar',
    category: 'Sayur',
    kcalPer100g: 15,
    proteinPer100g: 0.7,
    fatPer100g: 0.1,
    carbsPer100g: 3.6,
  ),
  FoodItem(
    id: 'f32',
    name: 'Tomat segar',
    category: 'Sayur',
    kcalPer100g: 18,
    proteinPer100g: 0.9,
    fatPer100g: 0.2,
    carbsPer100g: 3.9,
  ),
  FoodItem(
    id: 'f33',
    name: 'Sayur sop',
    category: 'Sayur',
    kcalPer100g: 35,
    proteinPer100g: 1.5,
    fatPer100g: 1.0,
    carbsPer100g: 5.0,
    note: 'Resep dan minyak memengaruhi nilai',
  ),
  FoodItem(
    id: 'f34',
    name: 'Gado-gado dengan saus',
    category: 'Masakan',
    kcalPer100g: 130,
    proteinPer100g: 5.0,
    fatPer100g: 8.0,
    carbsPer100g: 11.0,
    note: 'Sangat bergantung pada jumlah saus kacang',
  ),
  FoodItem(
    id: 'f35',
    name: 'Soto ayam',
    category: 'Masakan',
    kcalPer100g: 75,
    proteinPer100g: 6.0,
    fatPer100g: 4.0,
    carbsPer100g: 3.0,
    note: 'Estimasi kuah dan isian',
  ),
  FoodItem(
    id: 'f36',
    name: 'Sate ayam dengan saus kacang',
    category: 'Masakan',
    kcalPer100g: 220,
    proteinPer100g: 19.0,
    fatPer100g: 12.0,
    carbsPer100g: 8.0,
  ),
  FoodItem(
    id: 'f37',
    name: 'Nasi goreng',
    category: 'Masakan',
    kcalPer100g: 190,
    proteinPer100g: 5.0,
    fatPer100g: 7.0,
    carbsPer100g: 27.0,
    note: 'Bervariasi menurut minyak dan topping',
  ),
  FoodItem(
    id: 'f38',
    name: 'Mie goreng',
    category: 'Masakan',
    kcalPer100g: 180,
    proteinPer100g: 5.0,
    fatPer100g: 7.0,
    carbsPer100g: 24.0,
  ),
  FoodItem(
    id: 'f39',
    name: 'Rendang sapi',
    category: 'Masakan',
    kcalPer100g: 193,
    proteinPer100g: 22.0,
    fatPer100g: 10.0,
    carbsPer100g: 4.0,
    note: 'Resep santan memengaruhi kalori',
  ),
  FoodItem(
    id: 'f40',
    name: 'Perkedel kentang',
    category: 'Masakan',
    kcalPer100g: 180,
    proteinPer100g: 4.0,
    fatPer100g: 10.0,
    carbsPer100g: 18.0,
  ),
  FoodItem(
    id: 'f41',
    name: 'Pisang',
    category: 'Buah',
    kcalPer100g: 89,
    proteinPer100g: 1.1,
    fatPer100g: 0.3,
    carbsPer100g: 22.8,
  ),
  FoodItem(
    id: 'f42',
    name: 'Apel dengan kulit',
    category: 'Buah',
    kcalPer100g: 52,
    proteinPer100g: 0.3,
    fatPer100g: 0.2,
    carbsPer100g: 13.8,
  ),
  FoodItem(
    id: 'f43',
    name: 'Pepaya',
    category: 'Buah',
    kcalPer100g: 43,
    proteinPer100g: 0.5,
    fatPer100g: 0.3,
    carbsPer100g: 10.8,
  ),
  FoodItem(
    id: 'f44',
    name: 'Semangka',
    category: 'Buah',
    kcalPer100g: 30,
    proteinPer100g: 0.6,
    fatPer100g: 0.2,
    carbsPer100g: 7.6,
  ),
  FoodItem(
    id: 'f45',
    name: 'Mangga',
    category: 'Buah',
    kcalPer100g: 60,
    proteinPer100g: 0.8,
    fatPer100g: 0.4,
    carbsPer100g: 15.0,
  ),
  FoodItem(
    id: 'f46',
    name: 'Jeruk',
    category: 'Buah',
    kcalPer100g: 47,
    proteinPer100g: 0.9,
    fatPer100g: 0.1,
    carbsPer100g: 11.8,
  ),
  FoodItem(
    id: 'f47',
    name: 'Alpukat',
    category: 'Buah',
    kcalPer100g: 160,
    proteinPer100g: 2.0,
    fatPer100g: 14.7,
    carbsPer100g: 8.5,
  ),
  FoodItem(
    id: 'f48',
    name: 'Kacang tanah sangrai',
    category: 'Camilan',
    kcalPer100g: 585,
    proteinPer100g: 24.0,
    fatPer100g: 49.0,
    carbsPer100g: 21.0,
  ),
  FoodItem(
    id: 'f49',
    name: 'Biskuit tawar',
    category: 'Camilan',
    kcalPer100g: 430,
    proteinPer100g: 8.0,
    fatPer100g: 12.0,
    carbsPer100g: 70.0,
  ),
  FoodItem(
    id: 'f50',
    name: 'Puding susu',
    category: 'Camilan',
    kcalPer100g: 120,
    proteinPer100g: 3.0,
    fatPer100g: 3.0,
    carbsPer100g: 20.0,
    note: 'Bergantung pada resep dan gula',
  ),
];

String formatKcal(double value) => value.round().toString();
String formatGram(double value) =>
    value.toStringAsFixed(value % 1 == 0 ? 0 : 1);

class DiaryMacroBar extends StatelessWidget {
  final String label;
  final double value;
  final double target;
  final Color color;

  const DiaryMacroBar({
    super.key,
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = target <= 0 ? 0.0 : (value / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: diaryDarkGreen),
              ),
            ),
            Text(
              '${formatGram(value)} / ${formatGram(target)} g',
              style: const TextStyle(
                fontSize: 10,
                color: diaryDarkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: diaryLine,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class DiarySectionCard extends StatelessWidget {
  final String title;
  final int kcal;
  final List<DiaryEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<DiaryEntry> onEdit;
  final ValueChanged<DiaryEntry> onDelete;

  const DiarySectionCard({
    super.key,
    required this.title,
    required this.kcal,
    required this.entries,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: diaryLine.withOpacity(0.75)),
        boxShadow: [
          BoxShadow(
            color: diaryDarkGreen.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                    color: diaryDarkGreen,
                  ),
                ),
              ),
              Text(
                '$kcal kcal',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: diaryDarkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.restaurant_outlined,
                    size: 18,
                    color: diarySage,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Belum ada makanan dicatat',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                  TextButton(onPressed: onAdd, child: const Text('+ Tambah')),
                ],
              ),
            )
          else ...[
            const Divider(height: 1, color: diaryLine),
            for (final entry in entries)
              _FoodEntryRow(
                entry: entry,
                onEdit: () => onEdit(entry),
                onDelete: () => onDelete(entry),
              ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline, size: 17),
                label: const Text('Tambah makanan'),
                style: TextButton.styleFrom(
                  foregroundColor: diaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FoodEntryRow extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FoodEntryRow({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: diaryCream,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              _foodIcon(entry.food.category),
              size: 18,
              color: diaryGreen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.food.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: diaryDarkGreen,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${formatGram(entry.grams)} g  •  ${entry.food.kcalPer100g.round()} kcal/100 g',
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.kcal.round()} kcal',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: diaryGreen,
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 120),
                icon: const Icon(
                  Icons.more_horiz,
                  size: 18,
                  color: Colors.black45,
                ),
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Ubah porsi')),
                  PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

IconData _foodIcon(String category) {
  switch (category) {
    case 'Protein':
      return Icons.egg_alt_outlined;
    case 'Sayur':
      return Icons.eco_outlined;
    case 'Buah':
      return Icons.spa_outlined;
    case 'Susu':
      return Icons.local_drink_outlined;
    case 'Camilan':
      return Icons.cookie_outlined;
    case 'Masakan':
      return Icons.soup_kitchen_outlined;
    default:
      return Icons.rice_bowl_outlined;
  }
}
