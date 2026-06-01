import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_strings.dart';
import '../widgets/shared_widgets.dart';
import '../firebase_auth/auth_service.dart';

// ─── Personal Information Screen ──────────────────────────────────────────────
class PersonalInfoScreen extends StatefulWidget {
  final AppLanguage language;
  const PersonalInfoScreen({super.key, this.language = AppLanguage.english});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _editing = false;
  final _authService = AuthService();
  bool _loading = true;
  bool _saving = false;
  bool _uploadingPhoto = false;

  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _nicCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  // originals for cancel
  String _origFullName = '';
  String _origEmail = '';
  String _origPhone = '';
  String _origNic = '';
  String _origAddress = '';
  String _origAccountNo = '';
  String _origMeterNo = '';
  String? _origPhotoUrl;

  String? _photoUrl;
  File? _photoFile;

  // Data fields (populated from Firestore)
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _nic = '';
  String _address = '';
  String _accountNo = '';
  String _meterNo = '';

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
        title: const Text('Personal Information'),
        actions: [
          GestureDetector(
            onTap: () {
              // Toggle edit/cancel
              if (!_editing) {
                // start editing: store originals
                _origPhotoUrl = _photoUrl;
                _origFullName = _fullName;
                _origEmail = _email;
                _origPhone = _phone;
                _origNic = _nic;
                _origAddress = _address;
                _origAccountNo = _accountNo;
                _origMeterNo = _meterNo;
                _fullNameCtrl.text = _fullName;
                _emailCtrl.text = _email;
                _phoneCtrl.text = _phone;
                _nicCtrl.text = _nic;
                _addressCtrl.text = _address;
                setState(() => _editing = true);
              } else {
                // cancel edits: revert
                _fullNameCtrl.text = _origFullName;
                _emailCtrl.text = _origEmail;
                _phoneCtrl.text = _origPhone;
                _nicCtrl.text = _origNic;
                _addressCtrl.text = _origAddress;
                setState(() {
                  _photoUrl = _origPhotoUrl;
                  _fullName = _origFullName;
                  _email = _origEmail;
                  _phone = _origPhone;
                  _nic = _origNic;
                  _address = _origAddress;
                  _accountNo = _origAccountNo;
                  _meterNo = _origMeterNo;
                  _editing = false;
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: _editing ? null : AppColors.actionGradient,
                color: _editing ? AppColors.surfaceRaised : null,
                borderRadius: BorderRadius.circular(8),
                border: _editing
                    ? Border.all(color: AppColors.border, width: 0.5)
                    : null,
              ),
              child: Text(
                _editing ? 'Cancel' : 'Edit',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Avatar section
              Center(
                child: GestureDetector(
                  onTap: _editing ? _pickProfilePhoto : null,
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1A4A80),
                        ),
                        child: ClipOval(
                          child: _photoFile != null
                              ? Image.file(_photoFile!, fit: BoxFit.cover)
                              : (_photoUrl != null && _photoUrl!.isNotEmpty)
                                  ? Image.file(File(_photoUrl!),
                                      fit: BoxFit.cover)
                                  : const Icon(Icons.person_rounded,
                                      size: 44, color: AppColors.accentBlue),
                        ),
                      ),
                      if (_editing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              gradient: AppColors.actionGradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.bgPrimary, width: 2),
                            ),
                            child: _uploadingPhoto
                                ? const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.camera_alt_rounded,
                                    size: 13, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_accountNo,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.accentBlue,
                            fontWeight: FontWeight.w600)),
              ),

              const SizedBox(height: 24),

              // Account info section
              const _SectionLabel(label: 'Account Details'),
              const SizedBox(height: 10),
              _InfoTile(
                label: 'CEB Account Number',
                value: _accountNo,
                icon: Icons.badge_rounded,
                editable: false,
              ),
              const SizedBox(height: 8),
              _InfoTile(
                label: 'Meter Number',
                value: _meterNo,
                icon: Icons.electrical_services_rounded,
                editable: false,
              ),

              const SizedBox(height: 20),

              // Personal info section
              const _SectionLabel(label: 'Personal Details'),
              const SizedBox(height: 10),
              _InfoTile(
                label: 'Full Name',
                value: _fullName,
                icon: Icons.person_outline_rounded,
                editable: _editing,
                controller: _fullNameCtrl,
                onChanged: (v) => setState(() => _fullName = v),
              ),
              const SizedBox(height: 8),
              _InfoTile(
                label: 'National ID (NIC)',
                value: _nic,
                icon: Icons.credit_card_rounded,
                editable: _editing,
                controller: _nicCtrl,
                onChanged: (v) => setState(() => _nic = v),
              ),

              const SizedBox(height: 20),

              // Contact section
              const _SectionLabel(label: 'Contact Information'),
              const SizedBox(height: 10),
              _InfoTile(
                label: 'Email Address',
                value: _email,
                icon: Icons.mail_outline_rounded,
                editable: _editing,
                controller: _emailCtrl,
                onChanged: (v) => setState(() => _email = v),
              ),
              const SizedBox(height: 8),
              _InfoTile(
                label: 'Mobile Number',
                value: _phone,
                icon: Icons.phone_rounded,
                editable: _editing,
                controller: _phoneCtrl,
                onChanged: (v) => setState(() => _phone = v),
              ),
              const SizedBox(height: 8),
              _InfoTile(
                label: 'Service Address',
                value: _address,
                icon: Icons.location_on_rounded,
                editable: _editing,
                controller: _addressCtrl,
                onChanged: (v) => setState(() => _address = v),
              ),

              const SizedBox(height: 28),

              if (_editing)
                _saving
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.actionGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        ),
                      )
                    : PrimaryButton(
                        label: 'Save Changes',
                        onTap: _saveChanges,
                      ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile({bool showLoading = false}) async {
    if (showLoading) {
      setState(() {
        _loading = true;
      });
    }
    try {
      final profile = await _authService.getCurrentUserProfile();
      if (profile != null) {
        _fullNameCtrl.text = profile.fullName;
        _emailCtrl.text = profile.email;
        _phoneCtrl.text = profile.mobile;
        _nicCtrl.text = profile.nic;
        _addressCtrl.text = profile.serviceAddress ?? '';

        setState(() {
          _photoUrl = profile.photoUrl;
          _fullName = profile.fullName;
          _email = profile.email;
          _phone = profile.mobile;
          _nic = profile.nic;
          _accountNo = profile.cebAccountNumber ?? '';
          _meterNo = profile.meterNumber ?? '';
          _address = profile.serviceAddress ?? '';

          _origPhotoUrl = profile.photoUrl;
          _origFullName = profile.fullName;
          _origEmail = profile.email;
          _origPhone = profile.mobile;
          _origNic = profile.nic;
          _origAddress = profile.serviceAddress ?? '';
          _origAccountNo = profile.cebAccountNumber ?? '';
          _origMeterNo = profile.meterNumber ?? '';
        });
      }
    } catch (_) {
      // ignore errors and keep defaults
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (!_editing) return;

    final messenger = ScaffoldMessenger.of(context);

    final fullName = _fullNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final mobile = _phoneCtrl.text.trim();
    final nic = _nicCtrl.text.trim();
    final address = _addressCtrl.text.trim();

    if (fullName.isEmpty || email.isEmpty || mobile.isEmpty || nic.isEmpty) {
      messenger.showSnackBar(const SnackBar(
        content: Text('Please fill in all required fields.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    setState(() => _saving = true);

    try {
      final current = await _authService.getCurrentUserProfile();
      if (current == null) {
        if (!mounted) return;
        setState(() => _saving = false);
        messenger.showSnackBar(const SnackBar(
          content: Text('No signed-in user.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
        return;
      }

      final updated = await _authService.updateUserProfile(
        uid: current.uid,
        fullName: fullName,
        email: email,
        mobile: mobile,
        nic: nic,
        cebAccountNumber: _accountNo,
        meterNumber: _meterNo,
        serviceAddress: address,
        photoUrl: _photoUrl,
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
        _editing = false;
        _fullName = updated.fullName;
        _email = updated.email;
        _phone = updated.mobile;
        _nic = updated.nic;
        _address = updated.serviceAddress ?? '';
        _photoUrl = updated.photoUrl;

        _origPhotoUrl = updated.photoUrl;
        _origFullName = updated.fullName;
        _origEmail = updated.email;
        _origPhone = updated.mobile;
        _origNic = updated.nic;
        _origAddress = updated.serviceAddress ?? '';
        _origAccountNo = updated.cebAccountNumber ?? '';
        _origMeterNo = updated.meterNumber ?? '';
      });

      messenger.showSnackBar(const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
      ));

      await _loadProfile(showLoading: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(
        content: Text('Failed to update profile: ${e.toString()}'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _pickProfilePhoto() async {
    if (!_editing || _uploadingPhoto) return;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() {
      _uploadingPhoto = true;
    });

    final messenger = mounted ? ScaffoldMessenger.of(context) : null;

    try {
      final file = File(picked.path);
      if (!mounted) return;
      setState(() {
        _photoFile = file;
        _photoUrl = file.path;
      });
      messenger?.showSnackBar(const SnackBar(
        content:
            Text('Profile photo updated locally. Save changes to persist.'),
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      messenger?.showSnackBar(SnackBar(
        content: Text('Failed to upload photo: ${e.toString()}'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) {
        setState(() {
          _uploadingPhoto = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _nicCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5));
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool editable;
  final ValueChanged<String>? onChanged;

  final TextEditingController? controller;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    this.editable = false,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(
            color: editable ? AppColors.accentBlue : AppColors.border,
            width: editable ? 1.0 : 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: editable ? AppColors.accentBlue : AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                editable
                    ? TextFormField(
                        controller: controller,
                        initialValue: controller != null ? null : value,
                        onChanged: onChanged,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      )
                    : Text(value,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (!editable)
            const Icon(Icons.lock_outline_rounded,
                size: 12, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
