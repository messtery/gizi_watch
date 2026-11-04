import 'package:flutter/material.dart';

// ==========================================
// GIZIWATCH COLOR PALETTE
// ==========================================

const Color cream = Color(0xFFF6F3EC);
const Color darkGreen = Color(0xFF183C28);
const Color primaryGreen = Color(0xFF2F6541);
const Color softGreen = Color(0xFFDDEADB);
const Color lightGreen = Color(0xFF477D58);
const Color beige = Color(0xFFE8E1D2);
const Color textDark = Color(0xFF26352A);
const Color textGrey = Color(0xFF858B84);
const Color logoutRed = Color(0xFFC64D4D);

// ==========================================
// PROFILE PAGE
// ==========================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Temporary dummy data
  final String userName = 'Sarah Jenkins';
  final String userEmail = 'sarah.jenkins@gmail.com';

  final String dateOfBirth = '14 Mar 2001 · 25 y';
  final String gender = 'Female';
  final String pregnancy = 'None';
  final String height = '158 cm';
  final String weight = '55.0 kg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      // HEADER
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: ProfileHeader(
          onBack: () => Navigator.maybePop(context),
          onSettings: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings coming soon'),
              ),
            );
          },
        ),
      ),

      // BODY
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              // PROFILE IDENTITY
              ProfileIdentity(
                name: userName,
                email: userEmail,
              ),

              const SizedBox(height: 32),

              // PERSONAL DETAILS
              PersonalDetailsCard(
                onEdit: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'About You connection will be added later.',
                      ),
                    ),
                  );
                },
                details: [
                  DetailItem(
                    label: 'Date of birth',
                    value: dateOfBirth,
                  ),
                  DetailItem(
                    label: 'Sex',
                    value: gender,
                  ),
                  DetailItem(
                    label: 'Pregnancy or breastfeeding',
                    value: pregnancy,
                  ),
                  DetailItem(
                    label: 'Height · Weight',
                    value: '$height · $weight',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // DAILY TARGETS
              const DailyTargetsCard(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // LOGOUT BUTTON
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: LogoutButton(
            onPressed: () => _showLogoutDialog(context),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // LOGOUT CONFIRMATION DIALOG
  // ==========================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Log Out?',
            style: TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: textGrey,
              fontSize: 14,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: textGrey,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: logoutRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Logout will be connected later.',
                    ),
                  ),
                );
              },

              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

// ==========================================
// 1. PROFILE HEADER
// ==========================================

class ProfileHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const ProfileHeader({
    super.key,
    required this.onBack,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: cream,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,

      title: const Text(
        'Profile',
        style: TextStyle(
          color: textDark,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),

      // BACK BUTTON
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(
              side: BorderSide(
                color: beige,
                width: 1,
              ),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: darkGreen,
                  size: 19,
                ),
              ),
            ),
          ),
        ),
      ),

      // SETTINGS BUTTON
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(
                side: BorderSide(
                  color: beige,
                  width: 1,
                ),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onSettings,
                child: const SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(
                    Icons.settings_outlined,
                    color: darkGreen,
                    size: 23,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. PROFILE IDENTITY
// ==========================================

class ProfileIdentity extends StatelessWidget {
  final String name;
  final String email;

  const ProfileIdentity({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final String initial = name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : '?';

    return Column(
      children: [
        // PROFILE AVATAR
        Container(
          width: 122,
          height: 122,
          decoration: BoxDecoration(
            color: softGreen,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFC6DCC5),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              color: primaryGreen,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // USER NAME
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: textDark,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        // EMAIL
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: textGrey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. PERSONAL DETAILS
// ==========================================

class DetailItem {
  final String label;
  final String value;

  const DetailItem({
    required this.label,
    required this.value,
  });
}

class PersonalDetailsCard extends StatelessWidget {
  final VoidCallback onEdit;
  final List<DetailItem> details;

  const PersonalDetailsCard({
    super.key,
    required this.onEdit,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: beige,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // CARD HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Personal Details',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // DETAILS LIST
          ...List.generate(details.length, (index) {
            return Column(
              children: [
                const Divider(
                  color: beige,
                  thickness: 1,
                  height: 1,
                ),
                DetailRow(item: details[index]),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ==========================================
// PERSONAL DETAIL ROW
// ==========================================

class DetailRow extends StatelessWidget {
  final DetailItem item;

  const DetailRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LABEL ON LEFT
          Expanded(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                color: textGrey,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // VALUE ON RIGHT
          Text(
            item.value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13.5,
              color: textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. DAILY TARGETS CARD
// ==========================================

class DailyTargetsCard extends StatelessWidget {
  const DailyTargetsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Daily Targets',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Calculated from your details above',
            style: TextStyle(
              color: Color(0xFFD2DED5),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          // TWO COLUMN GRID
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.8,

            children: const [
              TargetItem(
                label: 'Energy',
                value: '2,250',
                unit: 'kcal',
              ),

              TargetItem(
                label: 'Protein',
                value: '60',
                unit: 'g',
              ),

              TargetItem(
                label: 'Fat',
                value: '65',
                unit: 'g',
              ),

              TargetItem(
                label: 'Carbs',
                value: '360',
                unit: 'g',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// DAILY TARGET ITEM
// ==========================================

class TargetItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const TargetItem({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE1EAE2),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 5),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 5),

                Text(
                  unit,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. LOGOUT BUTTON
// ==========================================

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,

      child: OutlinedButton.icon(
        onPressed: onPressed,

        icon: const Icon(
          Icons.logout,
          size: 21,
        ),

        label: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: OutlinedButton.styleFrom(
          foregroundColor: logoutRed,
          backgroundColor: Colors.white,

          side: const BorderSide(
            color: Color(0xFFEBD8D8),
            width: 1,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}
