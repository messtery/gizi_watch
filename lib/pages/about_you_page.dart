import 'package:flutter/material.dart';

class AboutYouPage extends StatefulWidget {
  const AboutYouPage({Key? key}) : super(key: key);

  @override
  State<AboutYouPage> createState() => _AboutYouPageState();
}

enum Gender { female, male }

enum LifeStage { child, teen, adult, elderly, pregnant, breastfeeding }

class _AboutYouPageState extends State<AboutYouPage> {
  // Form Controllers
  final TextEditingController _nameController = TextEditingController(text: "Sarah Jenkins");
  final TextEditingController _dobController = TextEditingController(text: "14 / 08 / 1995");
  final TextEditingController _heightController = TextEditingController(text: "168");
  final TextEditingController _weightController = TextEditingController(text: "62");

  // Selection States
  Gender _selectedGender = Gender.female;
  LifeStage _selectedLifeStage = LifeStage.adult;

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2F5D3A);
    const textColor = Color(0xFF1C1F1A);
    const borderColor = Color(0xFFE2DEC3);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row 1: Header (Back Button, Step Progress Bar, Counter Text)
              Row(
                children: [
                  // Back Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.chevron_left, color: textColor),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Progress Bar
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 2 / 3,
                        minHeight: 8,
                        backgroundColor: Color(0xFFE2DEC3),
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Counter Text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: const Text(
                      '2 of 3',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Scrollable Form Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 2: Page Title & Description
                      const Text(
                        'About You',
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tell us a bit about yourself so we can personalize your daily nutrition targets.',
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Row 3: User Details (2 Columns per Row)
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Full Name',
                              placeholder: 'e.g. Alex',
                              controller: _nameController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              label: 'Date of Birth',
                              placeholder: 'DD / MM / YYYY',
                              controller: _dobController,
                              suffixIcon: Icons.calendar_today_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Height (cm)',
                              placeholder: '170',
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              label: 'Weight (kg)',
                              placeholder: '65',
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Row 4: Gender Selection (2 Columns)
                      const Text(
                        'Biological Gender',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSelectableCard(
                              label: 'Female',
                              icon: Icons.female,
                              isSelected: _selectedGender == Gender.female,
                              onTap: () => setState(() => _selectedGender = Gender.female),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSelectableCard(
                              label: 'Male',
                              icon: Icons.male,
                              isSelected: _selectedGender == Gender.male,
                              onTap: () => setState(() => _selectedGender = Gender.male),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Row 5: Life Stage Selection (3 Columns Grid)
                      const Text(
                        'Life Stage / Physiological State',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.1,
                        children: [
                          _buildGridCard('Child', Icons.child_care, LifeStage.child),
                          _buildGridCard('Teen', Icons.face, LifeStage.teen),
                          _buildGridCard('Adult', Icons.person, LifeStage.adult),
                          _buildGridCard('Elderly', Icons.elderly, LifeStage.elderly),
                          _buildGridCard('Pregnant', Icons.pregnant_woman, LifeStage.pregnant),
                          _buildGridCard('Nursing', Icons.favorite, LifeStage.breastfeeding),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Bottom Row: Continue Button
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate or submit form
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input Field Helper
  Widget _buildInputField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1F1A),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1C1F1A)),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: const Color(0xFF1C1F1A).withOpacity(0.35)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: const Color(0xFF2F5D3A))
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2DEC3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2F5D3A), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Horizontal Card Helper (Gender)
  Widget _buildSelectableCard({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF2F5D3A);
    const borderColor = Color(0xFFE2DEC3);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? primaryColor : const Color(0xFF1C1F1A).withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : const Color(0xFF1C1F1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid Card Helper (Life Stage)
  Widget _buildGridCard(String label, IconData icon, LifeStage stage) {
    final isSelected = _selectedLifeStage == stage;
    const primaryColor = Color(0xFF2F5D3A);
    const borderColor = Color(0xFFE2DEC3);

    return InkWell(
      onTap: () => setState(() => _selectedLifeStage = stage),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? primaryColor : const Color(0xFF1C1F1A).withOpacity(0.6),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : const Color(0xFF1C1F1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}