import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import '../firebase_auth/auth_service.dart';
import 'login_screen.dart';
import 'personal_info_screen.dart';
import 'payment_methods_screen.dart';
import 'notification_settings_screen.dart';
import 'security_screen.dart';
import 'help_support_screen.dart';

// ─── Screen 3B: Profile Settings ──────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  final AppLanguage language;
  final ValueChanged<AppLanguage>? onLanguageChanged;

  const ProfileScreen({
    super.key,
    this.language = AppLanguage.english,
    this.onLanguageChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AppLanguage _language;
  final _authService = AuthService();
  String _fullName = '';
  String _email = '';
  String _cebAccount = '';
  String? _photoUrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _language = widget.language;
    _loadProfile();
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language) {
      _language = widget.language;
    }
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final profile = await _authService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          _fullName = profile.fullName;
          _email = profile.email;
          _cebAccount = profile.cebAccountNumber ?? '';
          _photoUrl = profile.photoUrl;
        });
      }
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  AppStrings get _s => AppStrings(_language);

  String get _languageName => switch (_language) {
        AppLanguage.english => 'English',
        AppLanguage.sinhala => 'සිංහල',
        AppLanguage.tamil => 'தமிழ்',
      };

  void _openLanguageModal() {
    // ─── Screen 3C: Language Change Modal ─────────────────────────────────────
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2040),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _LanguageModalSheet(
        currentLanguage: _language,
        onSelect: (lang) {
          setState(() => _language = lang);
          widget.onLanguageChanged?.call(lang);
          Navigator.pop(context);
        },
      ),
    );
  }

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
                    _s.profileLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.edit_rounded,
                      size: 15, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Avatar
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceRaised,
                      image: _photoUrl != null && _photoUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(_photoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _photoUrl == null || _photoUrl!.isEmpty
                        ? const Icon(Icons.person_rounded,
                            size: 36, color: AppColors.accentBlue)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_fullName,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  _loading
                      ? const SizedBox()
                      : Text('$_email · $_cebAccount',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),

                  const SizedBox(height: 20),

                  ProfileMenuRow(
                    icon: Icons.account_circle_rounded,
                    label: _s.personalInfo,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                PersonalInfoScreen(language: _language))),
                  ),
                  ProfileMenuRow(
                    icon: Icons.credit_card_rounded,
                    label: _s.paymentMethods,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PaymentMethodsScreen())),
                  ),
                  ProfileMenuRow(
                    icon: Icons.notifications_rounded,
                    label: _s.notifSettings,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const NotificationSettingsScreen())),
                  ),
                  ProfileMenuRow(
                    icon: Icons.security_rounded,
                    label: _s.securityLabel,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SecurityScreen())),
                  ),

                  // Language row (highlighted)
                  GestureDetector(
                    onTap: _openLanguageModal,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        border: Border.all(color: AppColors.accentBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.language_rounded,
                              size: 16, color: AppColors.accentBlue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(_s.languageLabel,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500)),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _languageName,
                              key: ValueKey(_language),
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.accentBlue,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right,
                              size: 16, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),

                  ProfileMenuRow(
                    icon: Icons.help_rounded,
                    label: _s.helpSupport,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HelpSupportScreen())),
                  ),
                  ProfileMenuRow(
                    icon: Icons.logout_rounded,
                    label: _s.signOut,
                    iconColor: AppColors.dangerRed,
                    labelColor: AppColors.dangerRed,
                    onTap: () async {
                      try {
                        await _authService.signOut();
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(language: _language),
                          ),
                          (route) => false,
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to sign out: ${e.toString()}'),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // App version
                  const Text('eVolt v1.0 · CEB Billing System',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textMuted)),
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

// ─── Screen 3C: Language Modal Bottom Sheet ────────────────────────────────────
class _LanguageModalSheet extends StatefulWidget {
  final AppLanguage currentLanguage;
  final ValueChanged<AppLanguage> onSelect;

  const _LanguageModalSheet({
    required this.currentLanguage,
    required this.onSelect,
  });

  @override
  State<_LanguageModalSheet> createState() => _LanguageModalSheetState();
}

class _LanguageModalSheetState extends State<_LanguageModalSheet> {
  late AppLanguage _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          const Text('Select Language',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),

          LanguageOptionTile(
            flag: '🇬🇧',
            nativeName: 'English',
            englishName: 'English',
            selected: _selected == AppLanguage.english,
            onTap: () => setState(() => _selected = AppLanguage.english),
          ),
          const SizedBox(height: 8),
          LanguageOptionTile(
            flag: '🇱🇰',
            nativeName: 'සිංහල',
            englishName: 'Sinhala',
            selected: _selected == AppLanguage.sinhala,
            onTap: () => setState(() => _selected = AppLanguage.sinhala),
          ),
          const SizedBox(height: 8),
          LanguageOptionTile(
            flag: '🇱🇰',
            nativeName: 'தமிழ்',
            englishName: 'Tamil',
            selected: _selected == AppLanguage.tamil,
            onTap: () => setState(() => _selected = AppLanguage.tamil),
          ),
          const SizedBox(height: 14),

          PrimaryButton(
            label: 'Apply',
            onTap: () => widget.onSelect(_selected),
          ),
          const SizedBox(height: 8),
          GhostButton(
            label: 'Cancel',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
