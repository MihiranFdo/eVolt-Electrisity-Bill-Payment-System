import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import 'bill_details_screen.dart';
import 'history_screen.dart';
import 'help_support_screen.dart';
import 'usage_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

// ─── Screen 2A (+ 3D Sinhala / 3E Tamil): Home Dashboard ─────────────────────
class HomeScreen extends StatefulWidget {
  final AppLanguage language;
  const HomeScreen({super.key, this.language = AppLanguage.english});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  late AppLanguage _language;

  @override
  void initState() {
    super.initState();
    _language = widget.language;
  }

  AppStrings get _s => AppStrings(_language);

  void _changeLanguage(AppLanguage lang) => setState(() => _language = lang);

  @override
  Widget build(BuildContext context) {
    final screens = [
      _HomeTab(language: _language, onNavigate: (i) => setState(() => _navIndex = i)),
      BillDetailsScreen(language: _language),
      UsageScreen(language: _language),
      NotificationsScreen(language: _language),
      ProfileScreen(language: _language, onLanguageChanged: _changeLanguage),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey(_navIndex),
          child: screens[_navIndex],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        labels: [_s.navHome, _s.navBills, _s.navUsage, _s.navAlerts, _s.navProfile],
      ),
    );
  }
}

// ─── Home Tab content ─────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final AppLanguage language;
  final ValueChanged<int> onNavigate;

  const _HomeTab({required this.language, required this.onNavigate});

  AppStrings get _s => AppStrings(language);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _s.greeting,
                            key: ValueKey(language),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                        const Text(
                          'Kasun Perera 👋',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceRaised,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_rounded,
                            size: 18, color: AppColors.textSecondary),
                      ),
                      Positioned(
                        top: 6, right: 6,
                        child: Container(
                          width: 7, height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.alertBadge,
                            border: Border.all(color: AppColors.bgPrimary, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bill card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BillCard(
                amount: 'LKR 4,280',
                dueDate: 'Due: 25 May 2026',
                daysLeft: '3 days left',
                payNowLabel: _s.payNow,
                currentBillLabel: _s.currentBill,
                onPayTap: () => onNavigate(1),
              ),
            ),

            const SizedBox(height: 16),

            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickAction(
                    icon: Icons.receipt_long_rounded,
                    iconColor: AppColors.accentBlue,
                    bgColor: const Color(0xFF0E3A6E),
                    label: _s.billDetails,
                    onTap: () => onNavigate(1),
                  ),
                  _QuickAction(
                    icon: Icons.show_chart_rounded,
                    iconColor: AppColors.successGreen,
                    bgColor: const Color(0xFF0E3A1A),
                    label: _s.usageLabel,
                    onTap: () => onNavigate(2),
                  ),
                  _QuickAction(
                    icon: Icons.history_rounded,
                    iconColor: AppColors.warningOrange,
                    bgColor: const Color(0xFF3A1A00),
                    label: _s.historyLabel,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HistoryScreen(language: language))),
                  ),
                  _QuickAction(
                    icon: Icons.headset_mic_rounded,
                    iconColor: AppColors.supportPurple,
                    bgColor: const Color(0xFF2A0A3A),
                    label: _s.supportLabel,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Recent activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _s.recentActivity,
                  key: ValueKey(language),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
              ),
            ),
            const SizedBox(height: 4),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ActivityRow(
                    icon: Icons.check_circle_rounded,
                    iconColor: AppColors.successGreen,
                    iconBg: Color(0xFF0E3A1A),
                    title: 'Payment successful',
                    subtitle: 'April 2026',
                    amount: '-3,950',
                    amountColor: AppColors.successGreen,
                  ),
                  Divider(color: AppColors.border, height: 1, thickness: 0.5),
                  ActivityRow(
                    icon: Icons.notifications_rounded,
                    iconColor: AppColors.warningOrange,
                    iconBg: Color(0xFF3A1A00),
                    title: 'Bill generated',
                    subtitle: 'May 2026',
                    amount: '4,280',
                    amountColor: AppColors.textSecondary,
                  ),
                  Divider(color: AppColors.border, height: 1, thickness: 0.5),
                  ActivityRow(
                    icon: Icons.bolt_rounded,
                    iconColor: AppColors.accentBlue,
                    iconBg: Color(0xFF0E3A6E),
                    title: '512 kWh consumed',
                    subtitle: 'This month',
                    amount: '↑ 8%',
                    amountColor: AppColors.accentBlue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
