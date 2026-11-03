import 'package:flutter/material.dart';

const kCream = Color(0xFFF4F1EA);
const kGreen = Color(0xFF2F5233);
const kInk = Color(0xFF1F3A2B);
const kMuted = Color(0xFF5E6B60);
const kLine = Color(0xFFE2DDD0);
const kSoft = Color(0xFFEEEADF);
const kDanger = Color(0xFFA8442F);

class FamilyMember {
  final String name;
  final String detail;
  const FamilyMember(this.name, this.detail);
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample data: replace with your real user / family data.
  final String _name = 'Nadia Putri';
  final String _email = 'nadia@email.com';
  final List<FamilyMember> _members = const [
    FamilyMember('Nadia', 'Female · Breastfeeding'),
    FamilyMember('Rafi', 'Male · 4 years'),
    FamilyMember('Ayu', 'Female · 1 year'),
  ];
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          children: [
            _header(context),
            const SizedBox(height: 18),
            _userCard(),
            _sectionLabel('Family members'),
            _familyCard(),
            _sectionLabel('Account'),
            _menuCard(),
            const SizedBox(height: 22),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: kDanger,
                side: const BorderSide(color: kDanger, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.maybePop(context),
          customBorder: const CircleBorder(),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: kLine),
            ),
            child: const Icon(Icons.chevron_left, size: 18, color: kInk),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontFamilyFallback: ['serif'],
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: kInk,
          ),
        ),
      ],
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: kLine),
  );

  Widget _userCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: kGreen,
            child: Text(
              _name[0],
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontFamilyFallback: ['serif'],
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _email,
                  style: const TextStyle(fontSize: 12, color: kMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: kMuted,
        ),
      ),
    );
  }

  Widget _familyCard() {
    return Container(
      decoration: _cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < _members.length; i++) _memberRow(i, _members[i]),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kLine, width: 1.5),
                    ),
                    child: const Icon(Icons.add, size: 16, color: kGreen),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Add family member',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberRow(int index, FamilyMember m) {
    final active = index == _activeIndex;
    return InkWell(
      onTap: () => setState(() => _activeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kLine)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: kSoft,
              child: Text(
                m.name[0],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kInk,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kInk,
                    ),
                  ),
                  Text(
                    m.detail,
                    style: const TextStyle(fontSize: 11, color: kMuted),
                  ),
                ],
              ),
            ),
            if (active)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            else
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kLine, width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard() {
    const items = ['Edit profile', 'Change password', 'About / Terms'];
    return Container(
      decoration: _cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: i == items.length - 1
                      ? null
                      : const Border(bottom: BorderSide(color: kLine)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        items[i],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: kInk,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: kMuted),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    // Same 5 tabs as the other screens. Profile is not a tab, so none is highlighted.
    return Container(
      decoration: const BoxDecoration(
        color: kCream,
        border: Border(top: BorderSide(color: kLine)),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: kCream,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kMuted,
        unselectedItemColor: kMuted,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Diary',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Body'),
          BottomNavigationBarItem(
            icon: Icon(Icons.ramen_dining_outlined),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'News',
          ),
        ],
      ),
    );
  }
}
