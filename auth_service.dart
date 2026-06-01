import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ── Roles ──────────────────────────────────────────────────────────────────────
enum UserRole { customer, meterReader, admin }

// ── UserProfile ────────────────────────────────────────────────────────────────
class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String mobile;
  final String nic;
  final UserRole role;
  final String? cebAccountNumber;
  final String? meterNumber;
  final String? serviceAddress;
  final String? photoUrl;

  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.nic,
    required this.role,
    this.cebAccountNumber,
    this.meterNumber,
    this.serviceAddress,
    this.photoUrl,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      mobile: data['mobile'] as String? ?? '',
      nic: data['nic'] as String? ?? '',
      role: _roleFromString(data['role'] as String? ?? 'customer'),
      cebAccountNumber: data['cebAccountNumber'] as String?,
      meterNumber: data['meterNumber'] as String?,
      serviceAddress: data['serviceAddress'] as String?,
      photoUrl: data['photoUrl'] as String?,
    );
  }

  // NOTE: No serverTimestamp here — createdAt is written separately only on registration
  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'email': email,
        'mobile': mobile,
        'nic': nic,
        'role': role.name,
        if (cebAccountNumber != null) 'cebAccountNumber': cebAccountNumber,
        if (meterNumber != null) 'meterNumber': meterNumber,
        if (serviceAddress != null) 'serviceAddress': serviceAddress,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };

  static UserRole _roleFromString(String s) => switch (s) {
        'admin' => UserRole.admin,
        'meterReader' => UserRole.meterReader,
        _ => UserRole.customer,
      };
}

// ── AuthException ──────────────────────────────────────────────────────────────
class AuthException implements Exception {
  final String code;
  final String message;
  AuthException(this.code, [this.message = '']);

  @override
  String toString() => message.isEmpty ? code : message;
}

// ── AuthService ────────────────────────────────────────────────────────────────
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ── Register ───────────────────────────────────────────────────────────────
  Future<UserProfile> registerCustomer({
    required String fullName,
    required String nic,
    required String email,
    required String mobile,
    required String password,
    required String cebAccountNumber,
    required String meterNumber,
    required String serviceAddress,
  }) async {
    // 1. Create Firebase Auth account
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = cred.user!.uid;

    // 2. Update display name (non-fatal if it fails)
    try {
      await cred.user!.updateDisplayName(fullName.trim());
    } catch (_) {}

    // 3. Build profile object
    final profile = UserProfile(
      uid: uid,
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      mobile: mobile.trim(),
      nic: nic.trim(),
      role: UserRole.customer,
      cebAccountNumber: cebAccountNumber.trim(),
      meterNumber: meterNumber.trim(),
      serviceAddress: serviceAddress.trim(),
      photoUrl: null,
    );

    // 4. Write to Firestore — createdAt added here only, NOT inside toMap()
    await _db.collection('users').doc(uid).set({
      ...profile.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    }).timeout(const Duration(seconds: 20));

    return profile;
  }

  // ── Sign In ────────────────────────────────────────────────────────────────
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _fetchProfile(cred.user!.uid);
  }

  // ── Fetch Profile ──────────────────────────────────────────────────────────
  Future<UserProfile> _fetchProfile(String uid) async {
    int attempts = 0;

    while (attempts < 3) {
      try {
        // First try: fetch from server with a longer timeout
        final doc = await _db
            .collection('users')
            .doc(uid)
            .get(const GetOptions(source: Source.server))
            .timeout(const Duration(seconds: 20)); // increased from 10 to 20

        if (!doc.exists) {
          throw AuthException('profile-not-found', 'User profile not found.');
        }
        return UserProfile.fromMap(uid, doc.data()!);
      } on TimeoutException {
        // Server timed out — try cache as fallback
        try {
          final cachedDoc = await _db
              .collection('users')
              .doc(uid)
              .get(const GetOptions(source: Source.cache));

          if (cachedDoc.exists) {
            return UserProfile.fromMap(uid, cachedDoc.data()!);
          }
        } catch (_) {
          // Cache also failed — will retry below
        }

        attempts++;
        if (attempts < 3) {
          await Future.delayed(Duration(milliseconds: 500 * (1 << attempts)));
          continue;
        }
        throw AuthException(
          'profile-fetch-failed',
          'Connection timed out. Please check your internet and try again.',
        );
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable' && attempts < 2) {
          // Try cache fallback first
          try {
            final cachedDoc = await _db
                .collection('users')
                .doc(uid)
                .get(const GetOptions(source: Source.cache));

            if (cachedDoc.exists) {
              return UserProfile.fromMap(uid, cachedDoc.data()!);
            }
          } catch (_) {}

          attempts++;
          await Future.delayed(Duration(milliseconds: 500 * (1 << attempts)));
          continue;
        }
        rethrow;
      }
    }

    throw AuthException(
      'profile-fetch-failed',
      'Could not load your profile. Please try again.',
    );
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _fetchProfile(user.uid);
  }

  // ── Update Profile ─────────────────────────────────────────────────────────
  Future<UserProfile> updateUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String mobile,
    required String nic,
    String? cebAccountNumber,
    String? meterNumber,
    String? serviceAddress,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.uid != uid) {
      throw AuthException('user-not-signed-in', 'No signed-in user.');
    }

    // Update display name (non-fatal)
    try {
      if (user.displayName != fullName.trim()) {
        await user.updateDisplayName(fullName.trim());
      }
    } catch (_) {}

    // Write only the changed fields — no serverTimestamp here
    final data = <String, dynamic>{
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'mobile': mobile.trim(),
      'nic': nic.trim(),
      if (cebAccountNumber != null) 'cebAccountNumber': cebAccountNumber.trim(),
      if (meterNumber != null) 'meterNumber': meterNumber.trim(),
      if (serviceAddress != null) 'serviceAddress': serviceAddress.trim(),
      if (photoUrl != null) 'photoUrl': photoUrl.trim(),
    };

    await _db
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true))
        .timeout(const Duration(seconds: 20));

    // Return profile directly from what we just wrote — no re-read needed
    return UserProfile(
      uid: uid,
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      mobile: mobile.trim(),
      nic: nic.trim(),
      role: UserRole.customer,
      cebAccountNumber: cebAccountNumber?.trim(),
      meterNumber: meterNumber?.trim(),
      serviceAddress: serviceAddress?.trim(),
      photoUrl: photoUrl?.trim(),
    );
  }

  // ── Upload Photo ───────────────────────────────────────────────────────────
  Future<String> uploadProfilePhoto(File imageFile, String uid) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_photos')
        .child('$uid.jpg');
    await ref.putFile(imageFile);
    return ref.getDownloadURL();
  }

  // ── Sign Out ───────────────────────────────────────────────────────────────
  Future<void> signOut() async => _auth.signOut();

  // ── Friendly Errors ────────────────────────────────────────────────────────
  static String friendlyError(Exception e) {
    if (e is FirebaseAuthException) {
      return switch (e.code) {
        'email-already-in-use' => 'An account with this email already exists.',
        'invalid-email' => 'Please enter a valid email address.',
        'weak-password' => 'Password must be at least 6 characters.',
        'user-not-found' => 'No account found with this email.',
        'wrong-password' => 'Incorrect password. Please try again.',
        'invalid-credential' =>
          'Incorrect email or password. Please try again.',
        'too-many-requests' => 'Too many attempts. Please try again later.',
        'network-request-failed' => 'No internet connection.',
        _ => 'Something went wrong. Please try again.',
      };
    }
    if (e is FirebaseException) {
      return switch (e.code) {
        'unavailable' => 'Service temporarily unavailable. Please try again.',
        'permission-denied' => 'Access denied. Please sign in again.',
        'not-found' => 'Data not found.',
        _ => 'A server error occurred. Please try again.',
      };
    }
    if (e is TimeoutException) {
      return 'Connection timed out. Please check your internet and try again.';
    }
    if (e is AuthException) {
      return e.message.isNotEmpty ? e.message : 'Something went wrong.';
    }
    return 'Something went wrong. Please try again.';
  }
}
