import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';

// ─── Screen 3A: Notifications ─────────────────────────────────────────────────
class NotificationsScreen extends StatelessWidget {
  final AppLanguage language;
  const NotificationsScreen({super.key, this.language = AppLanguage.english});

  AppStrings get _s => AppStrings(language);

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
                    _s.notifications,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                ),
                // Mark all read button
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.done_all_rounded, size: 16,
                      color: AppColors.accentBlue),
                ),
              ],
            ),
          ),

          // Unread badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                 decoration: BoxDecoration(
                   color: AppColors.accentBlue.withValues(alpha: 0.1),
                   border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
                   borderRadius: BorderRadius.circular(20),
                 ),
                child: const Text(
                  '2 unread',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.accentBlue,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                NotificationItem(
                  title: 'Bill due in 3 days',
                  body: 'Your May 2026 bill of LKR 4,280 is due on 25 May.',
                  time: 'Today, 8:00 AM',
                ),
                NotificationItem(
                  title: 'New bill generated',
                  body: 'Your May 2026 electricity bill has been generated.',
                  time: '10 May, 6:00 AM',
                ),
                NotificationItem(
                  title: 'Payment confirmed',
                  body: 'April 2026 bill payment of LKR 3,950 was successful.',
                  time: '22 Apr, 10:15 AM',
                  isRead: true,
                ),
                NotificationItem(
                  title: 'High usage alert',
                  body: 'Your usage is 8% higher than the same period last month.',
                  time: '18 Apr, 9:00 AM',
                  isRead: true,
                ),
                NotificationItem(
                  title: 'Anomaly detected',
                  body: 'Unusual spike in consumption detected. Please check your appliances.',
                  time: '5 Apr, 11:30 AM',
                  isRead: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
