import 'package:flutter/material.dart';
import '../firebase_auth/auth_service.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import 'home_screen.dart';

// ─── Registration Screen ───────────────────────────────────────────────────────
class RegistrationScreen extends StatefulWidget {
  final AppLanguage language;
  const RegistrationScreen({super.key, this.language = AppLanguage.english});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  int _step = 0; // 0 = Account, 1 = Meter, 2 = Review & Submit
  bool _agreeTerms = false;
  bool _loading = false;
  String? _errorMessage;

  // ── Step 1: Account fields ───────────────────────────────────────────────────
  final _nameCtrl = TextEditingController();
  final _nicCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  // ── Step 2: Meter fields ─────────────────────────────────────────────────────
  final _cebAccCtrl = TextEditingController();
  final _meterNoCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameCtrl.dispose();
    _nicCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _cebAccCtrl.dispose();
    _meterNoCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  // ── Validation ───────────────────────────────────────────────────────────────
  String? _validateStep0() {
    if (_nameCtrl.text.trim().isEmpty) {
      return 'Please enter your full name.';
    }
    if (_nicCtrl.text.trim().isEmpty) {
      return 'Please enter your NIC number.';
    }
    if (_emailCtrl.text.trim().isEmpty) {
      return 'Please enter your email address.';
    }
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$')
        .hasMatch(_emailCtrl.text.trim())) {
      return 'Please enter a valid email address.';
    }
    if (_mobileCtrl.text.trim().isEmpty) {
      return 'Please enter your mobile number.';
    }
    if (_passCtrl.text.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (_passCtrl.text != _confirmPassCtrl.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  String? _validateStep1() {
    if (_cebAccCtrl.text.trim().isEmpty) {
      return 'Please enter your CEB account number.';
    }
    if (_meterNoCtrl.text.trim().isEmpty) {
      return 'Please enter your meter number.';
    }
    if (_addressCtrl.text.trim().isEmpty) {
      return 'Please enter your service address.';
    }
    return null;
  }

// ── Navigation ───────────────────────────────────────────────────────────────
  Future<void> _nextStep() async {
    setState(() => _errorMessage = null);

    if (_step == 0) {
      final err = _validateStep0();
      if (err != null) {
        setState(() => _errorMessage = err);
        return;
      }
      setState(() => _step = 1);
    } else if (_step == 1) {
      final err = _validateStep1();
      if (err != null) {
        setState(() => _errorMessage = err);
        return;
      }
      setState(() => _step = 2);
    } else {
      await _register();
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() {
        _step--;
        _errorMessage = null;
      });
    }
  }

  // ── Registration ────────────────────────────────────────────────────────────
  Future<void> _register() async {
    if (!_agreeTerms) {
      setState(() =>
          _errorMessage = 'Please accept the Terms of Service to continue.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      // ignore: unused_local_variable
      final profile = await _authService.registerCustomer(
        fullName: _nameCtrl.text.trim(),
        nic: _nicCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        mobile: _mobileCtrl.text.trim(),
        password: _passCtrl.text,
        cebAccountNumber: _cebAccCtrl.text.trim(),
        meterNumber: _meterNoCtrl.text.trim(),
        serviceAddress: _addressCtrl.text.trim(),
      );

      if (!mounted) return;

      // Auto-login happens automatically — Firebase Auth already signed them in.
      // Just navigate directly to HomeScreen.
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(language: widget.language),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (e is Exception) {
          _errorMessage = AuthService.friendlyError(e);
        } else {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        }
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: GestureDetector(
          onTap: () => _step == 0 ? Navigator.pop(context) : _prevStep(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
        ),
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // Step indicator bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: List.generate(3, (i) {
                    final done = i < _step;
                    final active = i == _step;
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: (done || active)
                                    ? AppColors.actionGradient
                                    : null,
                                color:
                                    (done || active) ? null : AppColors.border,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          if (i < 2) const SizedBox(width: 6),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _stepLabel('Account', 0),
                    _stepLabel('Meter', 1),
                    _stepLabel('Review', 2),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Error banner
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: _ErrorBanner(message: _errorMessage!),
                ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _step == 0
                        ? _StepAccount(
                            key: const ValueKey(0),
                            nameCtrl: _nameCtrl,
                            nicCtrl: _nicCtrl,
                            emailCtrl: _emailCtrl,
                            mobileCtrl: _mobileCtrl,
                            passCtrl: _passCtrl,
                            confirmPassCtrl: _confirmPassCtrl,
                          )
                        : _step == 1
                            ? _StepMeter(
                                key: const ValueKey(1),
                                cebAccCtrl: _cebAccCtrl,
                                meterNoCtrl: _meterNoCtrl,
                                addressCtrl: _addressCtrl,
                              )
                            : _StepReview(
                                key: const ValueKey(2),
                                name: _nameCtrl.text.trim(),
                                email: _emailCtrl.text.trim(),
                                mobile: _mobileCtrl.text.trim(),
                                cebAccount: _cebAccCtrl.text.trim(),
                                meterNo: _meterNoCtrl.text.trim(),
                                address: _addressCtrl.text.trim(),
                              ),
                  ),
                ),
              ),

              // Bottom actions
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  children: [
                    if (_step == 2) ...[
                      GestureDetector(
                        onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                gradient: _agreeTerms
                                    ? AppColors.actionGradient
                                    : null,
                                color: _agreeTerms ? null : Colors.transparent,
                                border: Border.all(
                                    color: _agreeTerms
                                        ? Colors.transparent
                                        : AppColors.border),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: _agreeTerms
                                  ? const Icon(Icons.check,
                                      size: 12, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'I agree to the Terms of Service and Privacy Policy',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _loading
                        ? const _LoadingButton()
                        : PrimaryButton(
                            label: _step == 2 ? 'Create Account' : 'Continue →',
                            onTap: _nextStep,
                          ),
                    const SizedBox(height: 10),
                    if (_step == 0)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Already have an account? Sign in',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.accentBlue),
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

  Widget _stepLabel(String label, int index) {
    final active = _step == index;
    final done = _step > index;
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: active
            ? AppColors.accentBlue
            : done
                ? AppColors.textSecondary
                : AppColors.textMuted,
      ),
    );
  }
}

// ─── Step 1: Account Details ───────────────────────────────────────────────────
class _StepAccount extends StatelessWidget {
  final TextEditingController nameCtrl,
      nicCtrl,
      emailCtrl,
      mobileCtrl,
      passCtrl,
      confirmPassCtrl;

  const _StepAccount({
    super.key,
    required this.nameCtrl,
    required this.nicCtrl,
    required this.emailCtrl,
    required this.mobileCtrl,
    required this.passCtrl,
    required this.confirmPassCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Account Details',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text('Create your eVolt account',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        AppInputField(
            label: 'Full Name',
            hint: 'e.g. Kasun Perera',
            prefixIcon: Icons.person_outline_rounded,
            controller: nameCtrl),
        const SizedBox(height: 12),
        AppInputField(
            label: 'National ID (NIC)',
            hint: '199012345678',
            prefixIcon: Icons.credit_card_rounded,
            controller: nicCtrl),
        const SizedBox(height: 12),
        AppInputField(
            label: 'Email Address',
            hint: 'user@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            controller: emailCtrl),
        const SizedBox(height: 12),
        AppInputField(
            label: 'Mobile Number',
            hint: '+94 77 123 4567',
            prefixIcon: Icons.phone_rounded,
            controller: mobileCtrl),
        const SizedBox(height: 12),
        AppInputField(
            label: 'Password',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscure: true,
            controller: passCtrl),
        const SizedBox(height: 12),
        AppInputField(
            label: 'Confirm Password',
            hint: '••••••••',
            prefixIcon: Icons.lock_rounded,
            obscure: true,
            controller: confirmPassCtrl),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Step 2: Meter Details ─────────────────────────────────────────────────────
class _StepMeter extends StatelessWidget {
  final TextEditingController cebAccCtrl, meterNoCtrl, addressCtrl;

  const _StepMeter({
    super.key,
    required this.cebAccCtrl,
    required this.meterNoCtrl,
    required this.addressCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Meter Information',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text('Link your CEB electricity meter',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        AppInputField(
            label: 'CEB Account Number',
            hint: 'CEB-XXXXX',
            prefixIcon: Icons.badge_rounded,
            controller: cebAccCtrl),
        const SizedBox(height: 12),
        AppInputField(
            label: 'Meter Number',
            hint: 'MT-XXXX-XXX',
            prefixIcon: Icons.electrical_services_rounded,
            controller: meterNoCtrl),
        const SizedBox(height: 12),
        AppInputField(
            label: 'Service Address',
            hint: 'Full address of the meter premises',
            prefixIcon: Icons.location_on_rounded,
            controller: addressCtrl),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1E3A),
            border: Border.all(
                color: AppColors.accentBlue.withValues(alpha: 0.3), width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: AppColors.accentBlue),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your CEB Account Number and Meter Number are printed on your physical electricity bill or on the meter label.',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Step 3: Review & Confirm ─────────────────────────────────────────────────
class _StepReview extends StatelessWidget {
  final String name, email, mobile, cebAccount, meterNo, address;

  const _StepReview({
    super.key,
    required this.name,
    required this.email,
    required this.mobile,
    required this.cebAccount,
    required this.meterNo,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Review Your Details',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text('Please confirm everything looks correct',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 24),

        // Account summary
        _SectionCard(
          title: 'Account',
          icon: Icons.person_outline_rounded,
          rows: [
            _Row('Name', name),
            _Row('Email', email),
            _Row('Mobile', mobile),
          ],
        ),
        const SizedBox(height: 12),

        // Meter summary
        _SectionCard(
          title: 'Meter',
          icon: Icons.electrical_services_rounded,
          rows: [
            _Row('CEB Account', cebAccount),
            _Row('Meter No.', meterNo),
            _Row('Address', address),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_Row> rows;
  const _SectionCard(
      {required this.title, required this.icon, required this.rows});

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
          Row(children: [
            Icon(icon, size: 14, color: AppColors.accentBlue),
            const SizedBox(width: 6),
            Text(title,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentBlue)),
          ]),
          const SizedBox(height: 12),
          ...rows.map((r) => Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(r.label,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                      Flexible(
                        child: Text(r.value,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                if (r != rows.last) ...[
                  const SizedBox(height: 8),
                  const Divider(
                      color: AppColors.border, height: 1, thickness: 0.5),
                  const SizedBox(height: 8),
                ],
              ])),
        ],
      ),
    );
  }
}

class _Row {
  final String label, value;
  const _Row(this.label, this.value);
  @override
  bool operator ==(Object other) => other is _Row && other.label == label;
  @override
  int get hashCode => label.hashCode;
}

// ─── Shared widgets ───────────────────────────────────────────────────────────
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
            child: Text(message,
                style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

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
            strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
      ),
    );
  }
}
