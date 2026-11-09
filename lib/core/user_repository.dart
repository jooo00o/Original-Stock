import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// User profile and checkout contact information.
class UserProfileData {
  final String name;
  final String phone;
  final String address;
  final String email;

  const UserProfileData({
    this.name = '',
    this.phone = '',
    this.address = '',
    this.email = '',
  });

  UserProfileData copyWith({
    String? name,
    String? phone,
    String? address,
    String? email,
  }) {
    return UserProfileData(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
    );
  }
}

/// Abstract contract so backend API or alternate storage can replace it later.
abstract class IUserRepository {
  Future<UserProfileData> getUserProfile();
  Future<void> saveUserProfile(UserProfileData data);
  Future<void> clearUserProfile();
}

/// Concrete implementation storing checkout details in [FlutterSecureStorage].
class UserRepository implements IUserRepository {
  static const _keyName = 'user_name';
  static const _keyPhone = 'user_phone';
  static const _keyAddress = 'user_address';
  static const _keyEmail = 'user_email';

  final FlutterSecureStorage _storage;

  UserRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static final UserRepository instance = UserRepository();

  @override
  Future<UserProfileData> getUserProfile() async {
    try {
      final name = await _storage.read(key: _keyName) ?? '';
      final phone = await _storage.read(key: _keyPhone) ?? '';
      final address = await _storage.read(key: _keyAddress) ?? '';
      final email = await _storage.read(key: _keyEmail) ?? '';

      return UserProfileData(
        name: name,
        phone: phone,
        address: address,
        email: email,
      );
    } catch (_) {
      // Fallback in case of storage failure
      return const UserProfileData();
    }
  }

  @override
  Future<void> saveUserProfile(UserProfileData data) async {
    try {
      await _storage.write(key: _keyName, value: data.name);
      await _storage.write(key: _keyPhone, value: data.phone);
      await _storage.write(key: _keyAddress, value: data.address);
      await _storage.write(key: _keyEmail, value: data.email);
    } catch (_) {}
  }

  @override
  Future<void> clearUserProfile() async {
    try {
      await _storage.delete(key: _keyName);
      await _storage.delete(key: _keyPhone);
      await _storage.delete(key: _keyAddress);
      await _storage.delete(key: _keyEmail);
    } catch (_) {}
  }

  /// Egyptian phone number validation helper.
  /// Valid Egyptian numbers: 010, 011, 012, or 015 followed by 8 digits (11 digits total),
  /// or prefixed with +20 / 0020.
  static bool isValidEgyptianPhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'[\s\-]'), '');
    final regExp = RegExp(r'^(?:\+20|0020|0)?1[0125][0-9]{8}$');
    return regExp.hasMatch(clean);
  }

  /// Normalizes to standard 11-digit local format: 01XXXXXXXXX
  static String normalizeEgyptianPhone(String phone) {
    var clean = phone.replaceAll(RegExp(r'[\s\-]'), '');
    if (clean.startsWith('+20')) {
      clean = '0${clean.substring(3)}';
    } else if (clean.startsWith('0020')) {
      clean = '0${clean.substring(4)}';
    } else if (!clean.startsWith('0') && clean.length == 10) {
      clean = '0$clean';
    }
    return clean;
  }
}

