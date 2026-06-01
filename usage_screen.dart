import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';

// ─── Screen 2D: Usage Analytics ───────────────────────────────────────────────
class UsageScreen extends StatelessWidget {
  final AppLanguage language;
  const UsageScreen({super.key, this.language = AppLanguage.english});

  AppStrings get _s => AppStrings(language);

  // kWh values for Jan–Jun; Jun is prediction (greyed out)
  static const List<_MonthData> _months = [
    _MonthData('Jan', 320),
    _MonthData('Feb', 390),
    _MonthData('Mar', 290),
    _MonthData('Apr', 448),
    _MonthData('May', 512, isActive: true),
    _MonthData('Jun', 180, isPredicted: true),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Text(
                    _s.usageAnalytics,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  const Row(
                    children: [
                      Expanded(
                        child: SurfaceCard(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text('This month',
                                  style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              SizedBox(height: 4),
                              Text('512 kWh',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600,
                                      color: AppColors.accentBlue)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SurfaceCard(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text('vs last month',
                                  style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              SizedBox(height: 4),
                              Text('↑ 8%',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600,
                                      color: AppColors.warningOrange)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bar chart section
                  Text(_s.monthlyUsage,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  const SurfaceCard(
                    padding: EdgeInsets.all(14),
                    child: _BarChart(months: _months),
                  ),
                  const SizedBox(height: 16),

                  // Predicted bill
                  SurfaceCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E3A6E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.auto_graph_rounded,
                              size: 18, color: AppColors.accentBlue),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Predicted next bill',
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary)),
                              Text('Based on last 3 months average',
                                  style: TextStyle(
                                      fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        const Text('~LKR 3,900',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700,
                                color: AppColors.accentBlue)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tips
                  Text(_s.usageTips,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const _TipCard(
                    icon: Icons.lightbulb_rounded,
                    iconColor: Color(0xFFFBBF24),
                    text: 'Switch to LED bulbs to reduce lighting energy use by up to 75%.',
                  ),
                  const SizedBox(height: 8),
                  const _TipCard(
                    icon: Icons.ac_unit_rounded,
                    iconColor: AppColors.accentBlue,
                    text: 'Set your AC to 26°C — each degree lower increases energy use ~8%.',
                  ),
                  const SizedBox(height: 8),
                  const _TipCard(
                    icon: Icons.water_drop_rounded,
                    iconColor: AppColors.successGreen,
                    text: 'Unplug water heaters when not in use — they can account for 30% of your bill.',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bar Chart ─────────────────────────────────────────────────────────────────
class _MonthData {
  final String month;
  final int kwh;
  final bool isActive;
  final bool isPredicted;

  const _MonthData(this.month, this.kwh, {this.isActive = false, this.isPredicted = false});
}

class _BarChart extends StatelessWidget {
  final List<_MonthData> months;
  const _BarChart({required this.months});

  @override
  Widget build(BuildContext context) {
    final maxVal = months.map((m) => m.kwh).reduce((a, b) => a > b ? a : b).toDouble();

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: months.map((m) {
              final fraction = m.kwh / maxVal;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (m.isActive)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${m.kwh}',
                            style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w600,
                                color: AppColors.accentBlue),
                          ),
                        ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        height: 80 * fraction,
                        decoration: BoxDecoration(
                          color: m.isActive
                              ? AppColors.accentBlue
                               : m.isPredicted
                                   ? AppColors.border.withValues(alpha: 0.5)
                                   : const Color(0xFF1A4A80),
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: months
              .map((m) => Expanded(
                    child: Text(
                      m.month,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: m.isActive
                            ? AppColors.accentBlue
                            : AppColors.textMuted,
                        fontWeight:
                            m.isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _TipCard({required this.icon, required this.iconColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
