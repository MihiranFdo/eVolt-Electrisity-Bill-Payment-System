import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

// ─── Payment Methods Screen ────────────────────────────────────────────────────
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedIndex = 0;

  final List<_PaymentCard> _cards = [
    _PaymentCard(
      type: 'Visa',
      last4: '4821',
      expiry: '08/27',
      holderName: 'Kasun Perera',
      gradient: [const Color(0xFF1565C0), const Color(0xFF1A7FD4)],
    ),
    _PaymentCard(
      type: 'Mastercard',
      last4: '7392',
      expiry: '02/26',
      holderName: 'Kasun Perera',
      gradient: [const Color(0xFF4A148C), const Color(0xFF7B1FA2)],
    ),
  ];

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F2040),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(_).viewInsets.bottom,
            left: 20, right: 20, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 3,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Add New Card',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            const AppInputField(
                label: 'Card Number', hint: '1234 5678 9012 3456',
                prefixIcon: Icons.credit_card_rounded),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: AppInputField(
                    label: 'Expiry Date', hint: 'MM/YY',
                    prefixIcon: Icons.calendar_today_rounded)),
                SizedBox(width: 12),
                Expanded(child: AppInputField(
                    label: 'CVV', hint: '•••',
                    prefixIcon: Icons.lock_outline_rounded, obscure: true)),
              ],
            ),
            const SizedBox(height: 12),
            const AppInputField(
                label: 'Cardholder Name', hint: 'Full name on card',
                prefixIcon: Icons.person_outline_rounded),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Add Card', onTap: () => Navigator.pop(context)),
            const SizedBox(height: 12),
            GhostButton(label: 'Cancel', onTap: () => Navigator.pop(context)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

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
        title: const Text('Payment Methods'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Saved cards
              const Text('Saved Cards',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 12),

              ...List.generate(_cards.length, (i) {
                final card = _cards[i];
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: card.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                      border: _selectedIndex == i
                          ? Border.all(color: AppColors.accentBlue, width: 2)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          // Decorative circles
                           Positioned(
                             top: -10, right: -10,
                             child: Container(
                               width: 70, height: 70,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.white.withValues(alpha: 0.08),
                               ),
                             ),
                           ),
                           Positioned(
                             top: 10, right: 30,
                             child: Container(
                               width: 50, height: 50,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.white.withValues(alpha: 0.05),
                               ),
                             ),
                           ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(card.type,
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                                  if (_selectedIndex == i)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                       decoration: BoxDecoration(
                                         color: Colors.white.withValues(alpha: 0.2),
                                         borderRadius: BorderRadius.circular(6),
                                       ),
                                      child: const Text('Default',
                                          style: TextStyle(fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('•••• •••• •••• ${card.last4}',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white,
                                          letterSpacing: 2, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(card.holderName,
                                          style: const TextStyle(
                                              fontSize: 11, color: Color(0xFFCCE4FF))),
                                      Text('Exp: ${card.expiry}',
                                          style: const TextStyle(
                                              fontSize: 10, color: Color(0xFFCCE4FF))),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 8),

              // Other payment methods
              const Text('Other Methods',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 10),

              const _PaymentMethodTile(
                icon: Icons.account_balance_rounded,
                label: 'Bank Transfer',
                subtitle: 'Direct bank account payment',
                trailing: 'Connect',
                iconColor: AppColors.successGreen,
                iconBg: Color(0xFF0A2A1A),
              ),
              const SizedBox(height: 8),
              const _PaymentMethodTile(
                icon: Icons.phone_android_rounded,
                label: 'Mobile Wallet',
                subtitle: 'eZ Cash, mCash, FriMi',
                trailing: 'Connect',
                iconColor: AppColors.supportPurple,
                iconBg: Color(0xFF1A0A2A),
              ),

              const Spacer(),

              // Add card button
              GestureDetector(
                onTap: _showAddCardSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accentBlue, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, size: 18, color: AppColors.accentBlue),
                      SizedBox(width: 6),
                      Text('Add New Card',
                          style: TextStyle(fontSize: 13, color: AppColors.accentBlue,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentCard {
  final String type, last4, expiry, holderName;
  final List<Color> gradient;
  _PaymentCard({required this.type, required this.last4, required this.expiry,
    required this.holderName, required this.gradient});
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle, trailing;
  final Color iconColor, iconBg;
  const _PaymentMethodTile({
    required this.icon, required this.label, required this.subtitle,
    required this.trailing, required this.iconColor, required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13,
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(trailing, style: const TextStyle(fontSize: 11, color: AppColors.accentBlue,
              fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
