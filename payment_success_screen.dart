import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import 'home_screen.dart';

// ─── Screen 2C: Payment Success ───────────────────────────────────────────────
class PaymentSuccessScreen extends StatefulWidget {
  final AppLanguage language;
  const PaymentSuccessScreen({super.key, this.language = AppLanguage.english});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppStrings get _s => AppStrings(widget.language);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated success circle
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 80, height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0E4D2A),
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 42, color: AppColors.successGreen),
                ),
              ),
              const SizedBox(height: 16),

              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text(
                      _s.paymentSuccessful,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'LKR 4,280',
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w700,
                          color: AppColors.accentBlue, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'May 2026 electricity bill paid',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),

                    // Transaction details card
                    const SurfaceCard(
                      child: Column(
                        children: [
                          _TxnRow(label: 'Transaction ID', value: '#TXN-20260512-8841'),
                          _TxnRow(label: 'Date & time', value: '12 May 2026, 9:41 AM'),
                          _TxnRow(label: 'Payment method', value: 'Visa •••• 4291'),
                          _TxnRow(label: 'Account', value: 'CEB-00482', isLast: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    PrimaryButton(
                      label: _s.downloadReceipt,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    GhostButton(
                      label: _s.backToHome,
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => HomeScreen(language: widget.language)),
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TxnRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _TxnRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          Text(value,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
