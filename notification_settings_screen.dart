import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Notification Settings Screen ─────────────────────────────────────────────
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {

  // Toggle states
  bool _billGenerated     = true;
  bool _paymentReminder   = true;
  bool _overdueAlert      = true;
  bool _highUsage         = true;
  bool _anomalyDetection  = true;
  bool _newBillReady      = true;
  bool _pushNotif         = true;
  bool _inAppAlerts       = true;

  // Threshold slider
  double _highUsageThreshold = 25;

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
        title: const Text('Notification Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Delivery channels
              const _SectionHeader(label: 'Delivery Channels'),
              const SizedBox(height: 10),
              _ToggleTile(
                icon: Icons.notifications_active_rounded,
                iconColor: AppColors.accentBlue,
                iconBg: const Color(0xFF0A1E3A),
                label: 'Push Notifications',
                subtitle: 'Receive alerts on your device',
                value: _pushNotif,
                onChanged: (v) => setState(() => _pushNotif = v),
              ),
              const SizedBox(height: 8),
              _ToggleTile(
                icon: Icons.mark_chat_unread_rounded,
                iconColor: AppColors.supportPurple,
                iconBg: const Color(0xFF1A0A2A),
                label: 'In-App Alerts',
                subtitle: 'Show badge and alert inside app',
                value: _inAppAlerts,
                onChanged: (v) => setState(() => _inAppAlerts = v),
              ),

              const SizedBox(height: 24),

              // Billing notifications
              const _SectionHeader(label: 'Billing Notifications'),
              const SizedBox(height: 10),
              _ToggleTile(
                icon: Icons.receipt_long_rounded,
                iconColor: AppColors.successGreen,
                iconBg: const Color(0xFF0A2A1A),
                label: 'New Bill Generated',
                subtitle: 'Notify when a new bill is available',
                value: _billGenerated,
                onChanged: (v) => setState(() => _billGenerated = v),
              ),
              const SizedBox(height: 8),
              _ToggleTile(
                icon: Icons.alarm_rounded,
                iconColor: AppColors.warningOrange,
                iconBg: const Color(0xFF2A1A0A),
                label: 'Payment Due Reminder',
                subtitle: '5 days before due date',
                value: _paymentReminder,
                onChanged: (v) => setState(() => _paymentReminder = v),
              ),
              const SizedBox(height: 8),
              _ToggleTile(
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.dangerRed,
                iconBg: const Color(0xFF2A0A0A),
                label: 'Overdue Bill Alert',
                subtitle: 'Alert when payment is past due date',
                value: _overdueAlert,
                onChanged: (v) => setState(() => _overdueAlert = v),
              ),
              const SizedBox(height: 8),
              _ToggleTile(
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.accentBlue,
                iconBg: const Color(0xFF0A1E3A),
                label: 'New Bill Ready',
                subtitle: 'When monthly bill is available to view',
                value: _newBillReady,
                onChanged: (v) => setState(() => _newBillReady = v),
              ),

              const SizedBox(height: 24),

              // Usage alerts
              const _SectionHeader(label: 'Usage Alerts'),
              const SizedBox(height: 10),
              _ToggleTile(
                icon: Icons.bolt_rounded,
                iconColor: AppColors.warningOrange,
                iconBg: const Color(0xFF2A1A0A),
                label: 'High Usage Warning',
                subtitle: 'When usage exceeds threshold',
                value: _highUsage,
                onChanged: (v) => setState(() => _highUsage = v),
              ),

              // Threshold slider
              if (_highUsage) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    border: Border.all(color: AppColors.border, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('High Usage Threshold',
                              style: TextStyle(fontSize: 12,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A5F),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${_highUsageThreshold.round()}% above average',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.accentBlue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                          'Alert when monthly usage exceeds your average by this percentage',
                          style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.accentBlue,
                          inactiveTrackColor: AppColors.border,
                          thumbColor: AppColors.accentBlue,
                           overlayColor: AppColors.accentBlue.withValues(alpha: 0.15),
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                        ),
                        child: Slider(
                          min: 10,
                          max: 50,
                          divisions: 8,
                          value: _highUsageThreshold,
                          onChanged: (v) =>
                              setState(() => _highUsageThreshold = v),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('10%', style: TextStyle(
                              fontSize: 9, color: AppColors.textMuted)),
                          Text('50%', style: TextStyle(
                              fontSize: 9, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 8),
              _ToggleTile(
                icon: Icons.search_rounded,
                iconColor: AppColors.dangerRed,
                iconBg: const Color(0xFF2A0A0A),
                label: 'Anomaly Detection Alert',
                subtitle: 'Flag unusual spikes in consumption',
                value: _anomalyDetection,
                onChanged: (v) => setState(() => _anomalyDetection = v),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
            color: AppColors.textSecondary, letterSpacing: 0.5));
  }
}

// ─── Toggle Tile ───────────────────────────────────────────────────────────────
class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.label, required this.subtitle,
    required this.value, required this.onChanged,
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
            width: 34, height: 34,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13,
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(
                    fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.accentBlue,
            activeTrackColor: const Color(0xFF1A3A5F),
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}
