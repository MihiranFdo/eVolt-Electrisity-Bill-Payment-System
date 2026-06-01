// ─── Language Model ───────────────────────────────────────────────────────────
enum AppLanguage { english, sinhala, tamil }

class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  // ── Onboarding ──────────────────────────────────────────────────────────────
  String get chooseLanguage => switch (language) {
        AppLanguage.english => 'Choose your language',
        AppLanguage.sinhala => 'භාෂාව තෝරන්න',
        AppLanguage.tamil   => 'மொழியைத் தேர்ந்தெடு',
      };

  String get continueLabel => switch (language) {
        AppLanguage.english => 'Continue →',
        AppLanguage.sinhala => 'ඉදිරියට →',
        AppLanguage.tamil   => 'தொடர்க →',
      };

  String get tagline => switch (language) {
        AppLanguage.english => 'Smart electricity payments',
        AppLanguage.sinhala => 'බුද්ධිමත් විදුලි ගෙවීම්',
        AppLanguage.tamil   => 'சுறுசுறுப்பான மின் கட்டணம்',
      };

  // ── Login ───────────────────────────────────────────────────────────────────
  String get emailLabel => switch (language) {
        AppLanguage.english => 'Email address',
        AppLanguage.sinhala => 'ඊමේල් ලිපිනය',
        AppLanguage.tamil   => 'மின்னஞ்சல் முகவரி',
      };

  String get passwordLabel => switch (language) {
        AppLanguage.english => 'Password',
        AppLanguage.sinhala => 'මුරපදය',
        AppLanguage.tamil   => 'கடவுச்சொல்',
      };

  String get forgotPassword => switch (language) {
        AppLanguage.english => 'Forgot password?',
        AppLanguage.sinhala => 'මුරපදය අමතකද?',
        AppLanguage.tamil   => 'கடவுச்சொல் மறந்துவிட்டதா?',
      };

  String get signIn => switch (language) {
        AppLanguage.english => 'Sign in',
        AppLanguage.sinhala => 'පිවිසෙන්න',
        AppLanguage.tamil   => 'உள்நுழைக',
      };

  String get createAccount => switch (language) {
        AppLanguage.english => 'Create new account',
        AppLanguage.sinhala => 'නව ගිණුමක් හදන්න',
        AppLanguage.tamil   => 'புதிய கணக்கை உருவாக்கவும்',
      };

  String get changeLanguage => switch (language) {
        AppLanguage.english => 'Change language',
        AppLanguage.sinhala => 'භාෂාව වෙනස් කරන්න',
        AppLanguage.tamil   => 'மொழியை மாற்றவும்',
      };

  String get orLabel => switch (language) {
        AppLanguage.english => 'or',
        AppLanguage.sinhala => 'හෝ',
        AppLanguage.tamil   => 'அல்லது',
      };

  // ── Home ────────────────────────────────────────────────────────────────────
  String get greeting => switch (language) {
        AppLanguage.english => 'Good morning,',
        AppLanguage.sinhala => 'සුභ උදෑසනක්,',
        AppLanguage.tamil   => 'காலை வணக்கம்,',
      };

  String get currentBill => switch (language) {
        AppLanguage.english => 'Current Bill',
        AppLanguage.sinhala => 'වත්මන් බිල්',
        AppLanguage.tamil   => 'நடப்பு மசோதா',
      };

  String get payNow => switch (language) {
        AppLanguage.english => 'Pay Now',
        AppLanguage.sinhala => 'දැන් ගෙවන්න',
        AppLanguage.tamil   => 'இப்போது செலு',
      };

  String get recentActivity => switch (language) {
        AppLanguage.english => 'Recent Activity',
        AppLanguage.sinhala => 'මෑත ක්‍රියාකාරකම්',
        AppLanguage.tamil   => 'சமீபத்திய செயல்பாடு',
      };

  // ── Quick Actions ───────────────────────────────────────────────────────────
  String get billDetails => switch (language) {
        AppLanguage.english => 'Bill Details',
        AppLanguage.sinhala => 'බිල්',
        AppLanguage.tamil   => 'பில்',
      };

  String get usageLabel => switch (language) {
        AppLanguage.english => 'Usage',
        AppLanguage.sinhala => 'භාවිතය',
        AppLanguage.tamil   => 'பயன்பாடு',
      };

  String get historyLabel => switch (language) {
        AppLanguage.english => 'History',
        AppLanguage.sinhala => 'ඉතිහාස',
        AppLanguage.tamil   => 'வரலாறு',
      };

  String get supportLabel => switch (language) {
        AppLanguage.english => 'Support',
        AppLanguage.sinhala => 'සහාය',
        AppLanguage.tamil   => 'ஆதரவு',
      };

  // ── Bottom Nav ──────────────────────────────────────────────────────────────
  String get navHome => switch (language) {
        AppLanguage.english => 'Home',
        AppLanguage.sinhala => 'මුල',
        AppLanguage.tamil   => 'முகப்பு',
      };

  String get navBills => switch (language) {
        AppLanguage.english => 'Bills',
        AppLanguage.sinhala => 'බිල්',
        AppLanguage.tamil   => 'பில்',
      };

  String get navUsage => switch (language) {
        AppLanguage.english => 'Usage',
        AppLanguage.sinhala => 'භාවිත',
        AppLanguage.tamil   => 'பயன்',
      };

  String get navAlerts => switch (language) {
        AppLanguage.english => 'Alerts',
        AppLanguage.sinhala => 'අනතුරු',
        AppLanguage.tamil   => 'எச்சரிக்கை',
      };

  String get navProfile => switch (language) {
        AppLanguage.english => 'Profile',
        AppLanguage.sinhala => 'පැතිකඩ',
        AppLanguage.tamil   => 'சுயவிவரம்',
      };

  // ── Profile ─────────────────────────────────────────────────────────────────
  String get personalInfo  => 'Personal information';
  String get paymentMethods => 'Payment methods';
  String get notifSettings  => 'Notification settings';
  String get securityLabel  => 'Security & password';
  String get helpSupport    => 'Help & support';
  String get signOut        => 'Sign out';
  String get languageLabel  => switch (language) {
        AppLanguage.english => 'Language',
        AppLanguage.sinhala => 'භාෂාව',
        AppLanguage.tamil   => 'மொழி',
      };

  // ── Misc ────────────────────────────────────────────────────────────────────
  String get paymentSuccessful  => 'Payment Successful!';
  String get downloadReceipt    => 'Download Receipt';
  String get backToHome         => 'Back to Home';
  String get monthlyUsage       => 'Monthly usage (kWh)';
  String get usageTips          => 'Usage tips';
  String get selectLanguage     => 'Select Language';
  String get cancelLabel        => 'Cancel';
  String get notifications      => 'Notifications';
  String get profileLabel       => 'Profile';
  String get billDetailsTitle   => 'Bill Details';
  String get usageAnalytics     => 'Usage Analytics';
  String get totalDue           => 'Total Due';
}
