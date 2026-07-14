import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String email,
    required String name,
    String? photoBase64,
    required DateTime createdAt,
  }) = _UserProfile;
}
