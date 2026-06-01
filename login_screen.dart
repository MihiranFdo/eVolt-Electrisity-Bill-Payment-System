import 'package:flutter/material.dart';
import '../firebase_auth/auth_service.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import 'forgot_password_screen.dart';

// ─── Screen 1E / 1F: Login ────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  final AppLanguage language;
  const LoginScreen({super.key, this.language = AppLanguage.english});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AppLanguage _language;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  // ── Controllers ─────────────────────────────────────────────────────────────
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _errorMessage;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _language = widget.language;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  AppStrings get _s => AppStrings(_language);

  void _openLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2040),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _LanguageModalSheet(
        currentLanguage: _language,
        onSelect: (lang) {
          setState(() => _language = lang);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── Sign-in ───────────────────────────────────────────────────────────────
  Future<void> _signIn() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    // Basic client-side validation
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email and password.');
      return;
    }

    setState(() => _loading = true);

    try {
      final profile = await _authService.signIn(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // ✓ Stop spinner before navigation
      setState(() => _loading = false);

      // Navigate based on role
      final destination = switch (profile.role) {
        UserRole.admin =>
          HomeScreen(language: _language), // swap for AdminDashboard later
        UserRole.meterReader =>
          HomeScreen(language: _language), // swap for MeterReaderScreen later
        UserRole.customer => HomeScreen(language: _language),
      };

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => destination,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e is Exception
            ? AuthService.friendlyError(e)
            : 'An unexpected error occurred. Please try again.';
        _loading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Logo block
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.actionGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.bolt_rounded,
                              size: 28, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text('eVolt',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _s.tagline,
                            key: ValueKey(_language),
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textHint),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Error banner
                        if (_errorMessage != null) ...[
                          _ErrorBanner(message: _errorMessage!),
                          const SizedBox(height: 14),
                        ],

                        // Email field
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: AppInputField(
                            key: ValueKey('email_$_language'),
                            label: _s.emailLabel,
                            hint: 'user@example.com',
                            prefixIcon: Icons.mail_outline_rounded,
                            controller: _emailCtrl,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Password field
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: AppInputField(
                            key: ValueKey('pass_$_language'),
                            label: _s.passwordLabel,
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscure: true,
                            controller: _passCtrl,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen())),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _s.forgotPassword,
                                key: ValueKey('fp_$_language'),
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.accentBlue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Sign in button
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _loading
                              ? const _LoadingButton()
                              : PrimaryButton(
                                  key: ValueKey('signin_$_language'),
                                  label: _s.signIn,
                                  onTap: _signIn,
                                ),
                        ),

                        // OR divider
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Divider(
                                      color: AppColors.border, thickness: 0.5)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    _s.orLabel,
                                    key: ValueKey('or_$_language'),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted),
                                  ),
                                ),
                              ),
                              const Expanded(
                                  child: Divider(
                                      color: AppColors.border, thickness: 0.5)),
                            ],
                          ),
                        ),

                        // Create account
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: GhostButton(
                            key: ValueKey('create_$_language'),
                            label: _s.createAccount,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RegistrationScreen(
                                        language: _language))),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Change language hint bar
                GestureDetector(
                  onTap: _openLanguagePicker,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      border: Border.all(color: AppColors.border, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.language_rounded,
                            size: 15, color: AppColors.accentBlue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _s.changeLanguage,
                              key: ValueKey(_language),
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Error Banner ─────────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A0A0A),
        border: Border.all(
            color: Colors.redAccent.withValues(alpha: 0.4), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading Button ───────────────────────────────────────────────────────────
class _LoadingButton extends StatelessWidget {
  const _LoadingButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.actionGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}

// ─── Language Modal Sheet ─────────────────────────────────────────────────────
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
          Container(
            width: 32,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select Language',
              style: TextStyle(
                  fontSize: 15,
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
              label: 'Apply', onTap: () => widget.onSelect(_selected)),
          const SizedBox(height: 8),
          GhostButton(label: 'Cancel', onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
