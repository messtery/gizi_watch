import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutYouPage extends StatefulWidget {
  const AboutYouPage({super.key});

  @override
  State<AboutYouPage> createState() => _AboutYouPageState();
}

enum Gender { female, male }

enum LifeStage { pregnant, breastfeeding }

class _AboutYouPageState extends State<AboutYouPage> {
  // Form Controllers
  final TextEditingController _nameController =
      TextEditingController(text: "Sarah Jenkins");
  final TextEditingController _dobController =
      TextEditingController(text: "14 / 08 / 1995");
  final TextEditingController _heightController =
      TextEditingController(text: "168");
  final TextEditingController _weightController =
      TextEditingController(text: "62");

  // Selection States
  Gender _selectedGender = Gender.female;
  final Set<LifeStage> _selectedLifeStages = {}; // Multiple selection / optional

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
              // --- ROW 1: HEADER (Back Button, Progress Bar, Counter) ---
              Row(
                children: [
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
                ],
              ),

              const SizedBox(height: 20),

              // --- SCROLLABLE FORM CONTENT ---
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- ROW 2: TITLE & DESCRIPTION ---
                      Text(
                        'About You',
                        style: GoogleFonts.fraunces(
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
                          color: textColor.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- ROW 3: USER DETAILS (1 COLUMN LAYOUT) ---
                      _buildInputField(
                        label: 'Full Name',
                        placeholder: 'e.g. Alex',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 14),
                      _buildInputField(
                        label: 'Date of Birth',
                        placeholder: 'DD / MM / YYYY',
                        controller: _dobController,
                        suffixIcon: Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 14),
                      _buildInputField(
                        label: 'Height (cm)',
                        placeholder: '170',
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      _buildInputField(
                        label: 'Weight (kg)',
                        placeholder: '65',
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 20),

                      // --- ROW 4: BIOLOGICAL GENDER (2 COLUMNS) ---
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
                              onTap: () => setState(
                                  () => _selectedGender = Gender.female),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSelectableCard(
                              label: 'Male',
                              icon: Icons.male,
                              isSelected: _selectedGender == Gender.male,
                              onTap: () => setState(
                                  () => _selectedGender = Gender.male),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // --- ROW 5: SPECIAL PHYSIOLOGICAL STATE (OPTIONAL) ---
                      Row(
                        children: [
                          const Text(
                            'Special Physiological State',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: textColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Optional',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select any condition that applies to customize your energy and nutrient target. You can leave this unselected.',
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withValues(alpha: 0.65),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildLifeStageOption(
                        stage: LifeStage.pregnant,
                        title: 'Pregnant',
                        description:
                            'Increases caloric, iron, and folate targets to support gestational needs.',
                        icon: Icons.pregnant_woman_rounded,
                        isSelected:
                            _selectedLifeStages.contains(LifeStage.pregnant),
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedLifeStages.add(LifeStage.pregnant);
                            } else {
                              _selectedLifeStages.remove(LifeStage.pregnant);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildLifeStageOption(
                        stage: LifeStage.breastfeeding,
                        title: 'Nursing / Breastfeeding',
                        description:
                            'Adjusts energy, protein, and hydration goals for lactation.',
                        icon: Icons.baby_changing_station_rounded,
                        isSelected: _selectedLifeStages
                            .contains(LifeStage.breastfeeding),
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedLifeStages.add(LifeStage.breastfeeding);
                            } else {
                              _selectedLifeStages
                                  .remove(LifeStage.breastfeeding);
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // --- BOTTOM ROW: CONTINUE BUTTON ---
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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

  // --- HELPER WIDGETS ---

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
            hintStyle: TextStyle(
                color: const Color(0xFF1C1F1A).withValues(alpha: 0.35)),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: const Color(0xFF2F5D3A))
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2DEC3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2F5D3A), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Gender Card Helper
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
          color: isSelected
              ? primaryColor.withValues(alpha: 0.12)
              : Colors.white,
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
              color: isSelected
                  ? primaryColor
                  : const Color(0xFF1C1F1A).withValues(alpha: 0.7),
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

  // Life Stage Checkbox Card Helper
  Widget _buildLifeStageOption({
    required LifeStage stage,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    const primaryColor = Color(0xFF2F5D3A);
    const textColor = Color(0xFF1C1F1A);
    const borderColor = Color(0xFFE2DEC3);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : borderColor,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.15)
                      : const Color(0xFFF6F3EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? primaryColor
                      : textColor.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? primaryColor : textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withValues(alpha: 0.7),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: isSelected,
                  onChanged: onChanged,
                  activeColor: primaryColor,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? primaryColor
                        : textColor.withValues(alpha: 0.4),
                    width: 1.5,
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