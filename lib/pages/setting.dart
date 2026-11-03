import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dipakai main.dart untuk mengganti tema seluruh aplikasi.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.system,
);

class _Pal {
  final bool dark;
  const _Pal(this.dark);

  Color get bg => dark ? const Color(0xFF131512) : const Color(0xFFF4F2EC);
  Color get card => dark ? const Color(0xFF1D201B) : Colors.white;
  Color get border => dark ? const Color(0xFF2E322B) : const Color(0xFFE6E2D8);
  Color get divider => dark ? const Color(0xFF2A2D27) : const Color(0xFFECE9E0);
  Color get ink => dark ? const Color(0xFFF2F0E8) : const Color(0xFF1C1C1A);
  Color get grey => dark ? const Color(0xFFA6A69B) : const Color(0xFF6B6B66);
  Color get green => dark ? const Color(0xFF8DB58D) : const Color(0xFF3F5B3F);
  Color get trackOn => dark ? const Color(0xFF5E8A5E) : const Color(0xFF3F5B3F);
  Color get trackOff =>
      dark ? const Color(0xFF3A3D35) : const Color(0xFFCBC8BA);
  Color get thumbOn => dark ? const Color(0xFFF2F0E8) : Colors.white;
  Color get thumbOff =>
      dark ? const Color(0xFFC9C7BC) : const Color(0xFFF4F2EC);
  Color get segBg => dark ? const Color(0xFF2A2D26) : const Color(0xFFF0EDE3);
  Color get segSel => dark ? const Color(0xFF3C4036) : Colors.white;
  Color get chevron => dark ? const Color(0xFFC9C7BC) : const Color(0xFF3A3A36);
  Color get danger => dark ? const Color(0xFFE58A70) : const Color(0xFFA8381B);
}

TextStyle _t(double size, FontWeight w, Color c, {double? spacing}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: w,
    color: c,
    letterSpacing: spacing,
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _mealLogging = true;
  bool _supplements = false;
  TimeOfDay _breakfast = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _lunch = const TimeOfDay(hour: 12, minute: 30);
  TimeOfDay _dinner = const TimeOfDay(hour: 19, minute: 0);

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(TimeOfDay current, ValueChanged<TimeOfDay> set) async {
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked != null) setState(() => set(picked));
  }

  @override
  Widget build(BuildContext context) {
    final p = _Pal(Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: p.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: p.border),
                      ),
                      child: Icon(Icons.chevron_left, size: 22, color: p.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: GoogleFonts.fraunces(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: p.ink,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(p, 'APPEARANCE'),
                    _card(p, [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme',
                              style: _t(14, FontWeight.w600, p.ink),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: p.segBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _segment(p, 'Light', ThemeMode.light),
                                  _segment(p, 'Dark', ThemeMode.dark),
                                  _segment(p, 'System', ThemeMode.system),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    _label(p, 'REMINDERS'),
                    _card(p, [
                      _toggleRow(
                        p,
                        'Meal logging',
                        "Reminds you if a meal isn't logged",
                        _mealLogging,
                        (v) => setState(() => _mealLogging = v),
                      ),
                      _divider(p),
                      _timeRow(
                        p,
                        'Breakfast',
                        _breakfast,
                        () => _pickTime(_breakfast, (t) => _breakfast = t),
                      ),
                      _timeRow(
                        p,
                        'Lunch',
                        _lunch,
                        () => _pickTime(_lunch, (t) => _lunch = t),
                      ),
                      _timeRow(
                        p,
                        'Dinner',
                        _dinner,
                        () => _pickTime(_dinner, (t) => _dinner = t),
                      ),
                      _divider(p),
                      _toggleRow(
                        p,
                        'Supplements',
                        'Daily reminder, e.g. iron tablets',
                        _supplements,
                        (v) => setState(() => _supplements = v),
                      ),
                    ]),
                    _label(p, 'YOUR DATA'),
                    _card(p, [
                      _navRow(
                        p,
                        'Export nutrition report',
                        'PDF of intake and weight history',
                      ),
                      _divider(p),
                      _navRow(p, 'Back up data', 'Last backup: [date]'),
                      _divider(p),
                      _navRow(
                        p,
                        'Restore from backup',
                        'Replaces the data on this phone',
                      ),
                    ]),
                    _label(p, 'ACCOUNT'),
                    _card(p, [
                      _navRow(p, 'Change password', null),
                      _divider(p),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Text(
                            'Delete account',
                            style: _t(14, FontWeight.w700, p.danger),
                          ),
                        ),
                      ),
                    ]),
                    _label(p, 'ABOUT'),
                    _card(p, [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data sources',
                              style: _t(14, FontWeight.w600, p.ink),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Food values: TKPI (Kemenkes). Daily targets: AKG 2019. BMI categories: Kemenkes.',
                              style: _t(11, FontWeight.w400, p.grey),
                            ),
                          ],
                        ),
                      ),
                      _divider(p),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'App version',
                              style: _t(14, FontWeight.w600, p.ink),
                            ),
                            Text(
                              '[1.0.0]',
                              style: _t(13, FontWeight.w400, p.grey),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(_Pal p, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(text, style: _t(11, FontWeight.w700, p.grey, spacing: 0.8)),
    );
  }

  Widget _card(_Pal p, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(_Pal p) => Divider(height: 1, thickness: 1, color: p.divider);

  Widget _segment(_Pal p, String label, ThemeMode mode) {
    final selected = themeModeNotifier.value == mode;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          themeModeNotifier.value = mode;
          setState(() {});
        },
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? p.segSel : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(p.dark ? 0.25 : 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: _t(13, selected ? FontWeight.w600 : FontWeight.w500, p.ink),
          ),
        ),
      ),
    );
  }

  Widget _toggleRow(
    _Pal p,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _t(14, FontWeight.w600, p.ink)),
                const SizedBox(height: 2),
                Text(subtitle, style: _t(11, FontWeight.w400, p.grey)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeTrackColor: p.trackOn,
            inactiveTrackColor: p.trackOff,
            thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? p.thumbOn : p.thumbOff,
            ),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            thumbIcon: WidgetStateProperty.all(const Icon(null)),
          ),
        ],
      ),
    );
  }

  Widget _timeRow(_Pal p, String label, TimeOfDay time, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: _t(13.5, FontWeight.w400, p.ink)),
            Text(_fmt(time), style: _t(13.5, FontWeight.w700, p.green)),
          ],
        ),
      ),
    );
  }

  Widget _navRow(_Pal p, String title, String? subtitle) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: subtitle == null ? 14 : 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _t(14, FontWeight.w600, p.ink)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: _t(11, FontWeight.w400, p.grey)),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: p.chevron),
          ],
        ),
      ),
    );
  }
}
