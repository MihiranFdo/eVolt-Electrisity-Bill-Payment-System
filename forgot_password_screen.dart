import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

// ─── Forgot Password Screen ────────────────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  int _step = 0; // 0=email, 1=otp, 2=new password, 3=success

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
    super.dispose();
  }

  void _next() => setState(() => _step = (_step + 1).clamp(0, 3));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _step < 3
          ? AppBar(
              backgroundColor: AppColors.bgPrimary,
              leading: GestureDetector(
                onTap: () => _step == 0
                    ? Navigator.pop(context)
                    : setState(() => _step--),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppColors.textPrimary),
              ),
              title: const Text('Reset Password'),
            )
          : null,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStep(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _StepEmail(key: const ValueKey(0), onNext: _next),
      1 => _StepOTP(key: const ValueKey(1), onNext: _next),
      2 => _StepNewPassword(key: const ValueKey(2), onNext: _next),
      _ => _StepSuccess(key: const ValueKey(3),
          onDone: () => Navigator.of(context).pop()),
    };
  }
}

// ─── Step 1: Enter Email ───────────────────────────────────────────────────────
class _StepEmail extends StatelessWidget {
  final VoidCallback onNext;
  const _StepEmail({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF0A1E3A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.lock_reset_rounded,
              size: 30, color: AppColors.accentBlue),
        ),
        const SizedBox(height: 20),
        const Text('Forgot Password?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text(
            'Enter the email address linked to your eVolt account and we\'ll send you a reset code.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 28),
        const AppInputField(label: 'Email Address', hint: 'user@example.com',
            prefixIcon: Icons.mail_outline_rounded),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Send Reset Code', onTap: onNext),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Center(
            child: Text('Back to Sign In',
                style: TextStyle(fontSize: 12, color: AppColors.accentBlue)),
          ),
        ),
      ],
    );
  }
}

// ─── Step 2: Enter OTP ────────────────────────────────────────────────────────
class _StepOTP extends StatelessWidget {
  final VoidCallback onNext;
  const _StepOTP({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF0A2A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.mark_email_read_rounded,
              size: 30, color: AppColors.successGreen),
        ),
        const SizedBox(height: 20),
        const Text('Check Your Email',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            children: [
              TextSpan(text: 'We sent a 6-digit code to '),
              TextSpan(
                text: 'kasun@email.com',
                style: TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // OTP boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (_) => _OTPBox()),
        ),
        const SizedBox(height: 24),
        PrimaryButton(label: 'Verify Code', onTap: onNext),
        const SizedBox(height: 12),
        Center(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              children: [
                TextSpan(text: "Didn't get a code? "),
                TextSpan(
                  text: 'Resend (59s)',
                  style: TextStyle(color: AppColors.accentBlue,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OTPBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44, height: 52,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
         border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text('_',
          style: TextStyle(fontSize: 20, color: AppColors.textMuted)),
    );
  }
}

// ─── Step 3: New Password ──────────────────────────────────────────────────────
class _StepNewPassword extends StatelessWidget {
  final VoidCallback onNext;
  const _StepNewPassword({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF1A0A2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.lock_rounded,
              size: 30, color: AppColors.supportPurple),
        ),
        const SizedBox(height: 20),
        const Text('Set New Password',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Choose a strong password for your account.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 28),
        const AppInputField(label: 'New Password', hint: '••••••••',
            prefixIcon: Icons.lock_outline_rounded, obscure: true),
        const SizedBox(height: 12),
        const AppInputField(label: 'Confirm Password', hint: '••••••••',
            prefixIcon: Icons.lock_rounded, obscure: true),
        const SizedBox(height: 16),

        // Strength requirements
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
              const Text('Password Requirements:',
                  style: TextStyle(fontSize: 10,
                      color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ...[
                '8+ characters',
                'Uppercase & lowercase letters',
                'At least one number',
                'At least one special character',
              ].map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(r, style: const TextStyle(
                        fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(label: 'Reset Password', onTap: onNext),
      ],
    );
  }
}

// ─── Step 4: Success ───────────────────────────────────────────────────────────
class _StepSuccess extends StatelessWidget {
  final VoidCallback onDone;
  const _StepSuccess({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF0A2A1A),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.successGreen, width: 2),
            ),
            child: const Icon(Icons.check_rounded, size: 44,
                color: AppColors.successGreen),
          ),
          const SizedBox(height: 24),
          const Text('Password Reset!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text(
              'Your password has been updated successfully.\nYou can now sign in with your new password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 32),
          PrimaryButton(label: 'Back to Sign In', onTap: onDone),
        ],
      ),
    );
  }
}
