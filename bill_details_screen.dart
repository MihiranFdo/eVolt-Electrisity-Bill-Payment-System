import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import 'payment_success_screen.dart';

// ─── Screen 2B: Bill Details ───────────────────────────────────────────────────
class BillDetailsScreen extends StatelessWidget {
  final AppLanguage language;
  const BillDetailsScreen({super.key, this.language = AppLanguage.english});

  AppStrings get _s => AppStrings(language);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 16,
                        color: AppColors.textSecondary),
                  ),
                ),
                Expanded(
                  child: Text(
                    _s.billDetailsTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                ),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.download_rounded, size: 16,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Account info banner
                  const SurfaceCard(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      children: [
                        Text('May 2026 · Account #CEB-00482',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        SizedBox(height: 2),
                        Text('Billing period: 01 May – 31 May 2026',
                            style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bill breakdown
                  const SurfaceCard(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Column(
                      children: [
                        BillDetailRow(label: 'Units consumed', value: '512 kWh'),
                        BillDetailRow(label: 'Energy charge', value: 'LKR 3,584'),
                        BillDetailRow(label: 'Fixed charge', value: 'LKR 400'),
                        BillDetailRow(label: 'LECO levy', value: 'LKR 180'),
                        BillDetailRow(label: 'Tax (VAT 18%)', value: 'LKR 116', isLast: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Total due
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A4A80),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Due',
                            style: TextStyle(fontSize: 13, color: Color(0xFFA8D8F0))),
                        Text('LKR 4,280',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700,
                                color: AppColors.accentBlue)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Status pair
                  const Row(
                    children: [
                      Expanded(
                        child: SurfaceCard(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text('Due date',
                                  style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              SizedBox(height: 4),
                              Text('25 May 2026',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                      color: AppColors.warningOrange)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SurfaceCard(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text('Status',
                                  style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              SizedBox(height: 4),
                              Text('Unpaid',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                      color: AppColors.dangerRed)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pay button
                  PrimaryButton(
                    label: 'Pay LKR 4,280',
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            PaymentSuccessScreen(language: language),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(opacity: anim, child: child),
                      ),
                    ),
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
