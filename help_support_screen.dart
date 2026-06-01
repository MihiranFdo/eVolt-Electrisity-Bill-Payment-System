import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Help & Support Screen ─────────────────────────────────────────────────────
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedFaq;

  final _faqs = const [
    _FAQ(
      q: 'How is my electricity bill calculated?',
      a: 'Your bill is calculated using the tiered CEB tariff structure. Units consumed are '
          'divided into blocks (0–30, 31–60, 61–90, 91–180, 181+ kWh), each charged at a '
          'progressively higher rate. Fixed charges, fuel adjustment charges, and VAT (15%) '
          'are added to the block total.',
    ),
    _FAQ(
      q: 'How accurate is the bill prediction?',
      a: 'The prediction uses a Weighted Moving Average (WMA) of your last 3–6 months of '
          'consumption. It gives more weight to recent months and typically achieves within '
          '10–15% accuracy (MAPE). Significant lifestyle changes may reduce accuracy.',
    ),
    _FAQ(
      q: 'What triggers an anomaly alert?',
      a: 'An alert is triggered when your current month\'s consumption exceeds your 3-month '
          'rolling average by more than 30% (default threshold). Causes include faulty '
          'appliances, meter tampering, or data entry errors.',
    ),
    _FAQ(
      q: 'How do I use the QR code on my meter?',
      a: 'Your CEB meter has a unique QR code. Scanning it opens a read-only view of your '
          'latest bill and payment status — no login required. For full history, you\'ll need '
          'to authenticate with your password or OTP.',
    ),
    _FAQ(
      q: 'Is my payment information safe?',
      a: 'The current version simulates payments for demonstration purposes. No real '
          'financial data is stored or processed. A production version would use a certified '
          'payment gateway (PayHere / Stripe) with full PCI-DSS compliance.',
    ),
    _FAQ(
      q: 'How do I dispute a bill?',
      a: 'If you believe there is an error in your bill, contact CEB at 1987 or visit your '
          'nearest CEB regional office. You can also submit a query through this app\'s '
          'support ticket system (Help & Support → Submit a Ticket).',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
        ),
        title: const Text('Help & Support'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Contact cards
              const Row(
                children: [
                  Expanded(child: _ContactCard(
                    icon: Icons.phone_rounded,
                    label: 'CEB Hotline',
                    value: '1987',
                    color: AppColors.successGreen,
                    bg: Color(0xFF0A2A1A),
                  )),
                  SizedBox(width: 10),
                  Expanded(child: _ContactCard(
                    icon: Icons.chat_bubble_rounded,
                    label: 'Live Chat',
                    value: 'Start chat',
                    color: AppColors.accentBlue,
                    bg: Color(0xFF0A1E3A),
                  )),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(child: _ContactCard(
                    icon: Icons.mail_rounded,
                    label: 'Email',
                    value: 'support@ceb.lk',
                    color: AppColors.supportPurple,
                    bg: Color(0xFF1A0A2A),
                  )),
                  SizedBox(width: 10),
                  Expanded(child: _ContactCard(
                    icon: Icons.location_on_rounded,
                    label: 'Nearest Office',
                    value: 'Find office',
                    color: AppColors.warningOrange,
                    bg: Color(0xFF2A1A0A),
                  )),
                ],
              ),

              const SizedBox(height: 24),

              // FAQs
              const Text('Frequently Asked Questions',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 10),

              ...List.generate(_faqs.length, (i) {
                final expanded = _expandedFaq == i;
                return GestureDetector(
                  onTap: () => setState(() =>
                  _expandedFaq = expanded ? null : i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      border: Border.all(
                          color: expanded
                              ? AppColors.accentBlue
                              : AppColors.border,
                          width: expanded ? 1.0 : 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(_faqs[i].q,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: expanded
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Icon(
                              expanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                        if (expanded) ...[
                          const SizedBox(height: 10),
                          const Divider(color: AppColors.border, height: 1),
                          const SizedBox(height: 10),
                          Text(_faqs[i].a,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary,
                                  height: 1.5)),
                        ],
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Submit ticket
              const Text('Submit a Ticket',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  border: Border.all(color: AppColors.border, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: const Row(
                        children: [
                          Text('Billing Dispute',
                              style: TextStyle(fontSize: 12,
                                  color: AppColors.textSecondary)),
                          Spacer(),
                          Icon(Icons.arrow_drop_down_rounded,
                              size: 18, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Describe your issue',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Container(
                      height: 90,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: const Text('Tap to describe your issue...',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.actionGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Submit Ticket',
                          style: TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQ {
  final String q, a;
  const _FAQ({required this.q, required this.a});
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color, bg;

  const _ContactCard({
    required this.icon, required this.label, required this.value,
    required this.color, required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 12,
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
