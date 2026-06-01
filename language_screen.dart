import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import 'login_screen.dart';

// ─── Screen 1B / 1C / 1D: Language Selection ─────────────────────────────────
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with SingleTickerProviderStateMixin {
  AppLanguage _selected = AppLanguage.english;

  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppStrings get _s => AppStrings(_selected);

  void _proceed() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginScreen(language: _selected),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Icon + heading
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      gradient: AppColors.actionGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.bolt_rounded, size: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _s.chooseLanguage,
                      key: ValueKey(_selected),
                      style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose your language · தேர்ந்தெடுக்கவும் · තෝරන්න',
                    style: TextStyle(fontSize: 11, color: AppColors.textHint),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 36),

                  // Language options
                  LanguageOptionTile(
                    flag: '🇬🇧',
                    nativeName: 'English',
                    englishName: 'English',
                    selected: _selected == AppLanguage.english,
                    onTap: () => setState(() => _selected = AppLanguage.english),
                  ),
                  const SizedBox(height: 10),
                  LanguageOptionTile(
                    flag: '🇱🇰',
                    nativeName: 'සිංහල',
                    englishName: 'Sinhala',
                    selected: _selected == AppLanguage.sinhala,
                    onTap: () => setState(() => _selected = AppLanguage.sinhala),
                  ),
                  const SizedBox(height: 10),
                  LanguageOptionTile(
                    flag: '🇱🇰',
                    nativeName: 'தமிழ்',
                    englishName: 'Tamil',
                    selected: _selected == AppLanguage.tamil,
                    onTap: () => setState(() => _selected = AppLanguage.tamil),
                  ),

                  const Spacer(),

                  // Continue button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: PrimaryButton(
                      key: ValueKey(_selected),
                      label: _s.continueLabel,
                      onTap: _proceed,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
