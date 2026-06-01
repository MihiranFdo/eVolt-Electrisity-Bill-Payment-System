import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

// ─── Security & Password Screen ───────────────────────────────────────────────
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometrics   = false;
  bool _twoFactor    = false;
  bool _sessionAlert = true;

  void _showChangePasswordSheet() {
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
                decoration: BoxDecoration(color: AppColors.border,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Change Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 20),
            const AppInputField(
                label: 'Current Password', hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded, obscure: true),
            const SizedBox(height: 12),
            const AppInputField(
                label: 'New Password', hint: '••••••••',
                prefixIcon: Icons.lock_rounded, obscure: true),
            const SizedBox(height: 12),
            const AppInputField(
                label: 'Confirm New Password', hint: '••••••••',
                prefixIcon: Icons.lock_rounded, obscure: true),
            const SizedBox(height: 8),

            // Password strength indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Password must contain:',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  ...[
                    '8 or more characters',
                    'At least one uppercase letter',
                    'At least one number',
                    'At least one special character',
                  ].map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 5, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(req, style: const TextStyle(
                            fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 16),
            PrimaryButton(
                label: 'Update Password',
                onTap: () => Navigator.pop(context)),
            const SizedBox(height: 8),
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
        title: const Text('Security & Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Security status card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.actionGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                       width: 44, height: 44,
                       decoration: BoxDecoration(
                         color: Colors.white.withValues(alpha: 0.15),
                         borderRadius: BorderRadius.circular(12),
                       ),
                      child: const Icon(Icons.shield_rounded,
                          size: 24, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Security',
                              style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.w600, color: Colors.white)),
                          SizedBox(height: 2),
                          Text('Your account is moderately protected',
                              style: TextStyle(fontSize: 10,
                                  color: Color(0xFFCCE4FF))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                       decoration: BoxDecoration(
                         color: Colors.white.withValues(alpha: 0.15),
                         borderRadius: BorderRadius.circular(8),
                       ),
                      child: const Text('Medium',
                          style: TextStyle(fontSize: 10,
                              color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text('Password',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: _showChangePasswordSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    border: Border.all(color: AppColors.border, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_rounded,
                          size: 16, color: AppColors.accentBlue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Change Password',
                                style: TextStyle(fontSize: 13,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500)),
                            Text('Last changed 3 months ago',
                                style: TextStyle(fontSize: 10,
                                    color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 16,
                          color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text('Authentication',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 10),

              _SecurityToggle(
                icon: Icons.fingerprint_rounded,
                iconColor: AppColors.accentBlue,
                iconBg: const Color(0xFF0A1E3A),
                label: 'Biometric Login',
                subtitle: 'Use fingerprint or face unlock',
                value: _biometrics,
                onChanged: (v) => setState(() => _biometrics = v),
              ),
              const SizedBox(height: 8),
              _SecurityToggle(
                icon: Icons.verified_user_rounded,
                iconColor: AppColors.successGreen,
                iconBg: const Color(0xFF0A2A1A),
                label: 'Two-Factor Authentication',
                subtitle: 'Verify login via OTP on your phone',
                value: _twoFactor,
                onChanged: (v) => setState(() => _twoFactor = v),
              ),
              const SizedBox(height: 8),
              _SecurityToggle(
                icon: Icons.devices_rounded,
                iconColor: AppColors.warningOrange,
                iconBg: const Color(0xFF2A1A0A),
                label: 'New Login Alert',
                subtitle: 'Notify when account is accessed from a new device',
                value: _sessionAlert,
                onChanged: (v) => setState(() => _sessionAlert = v),
              ),

              const SizedBox(height: 24),

              const Text('Account Actions',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 10),

              const _ActionTile(
                icon: Icons.logout_rounded,
                iconColor: AppColors.warningOrange,
                iconBg: Color(0xFF2A1A0A),
                label: 'Sign Out All Devices',
                subtitle: 'Revoke all active sessions',
              ),
              const SizedBox(height: 8),
              const _ActionTile(
                icon: Icons.delete_forever_rounded,
                iconColor: AppColors.dangerRed,
                iconBg: Color(0xFF2A0A0A),
                label: 'Delete Account',
                subtitle: 'Permanently remove your account and data',
                danger: true,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SecurityToggle({
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, subtitle;
  final bool danger;

  const _ActionTile({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.label, required this.subtitle, this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(
             color: danger ? AppColors.dangerRed.withValues(alpha: 0.3) : AppColors.border,
            width: 0.5),
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
                Text(label, style: TextStyle(fontSize: 13,
                    color: danger ? AppColors.dangerRed : AppColors.textPrimary,
                    fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(
                    fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
