import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class CurrentUser {
  final bool isInitialValue;
  final User data;

  const CurrentUser._(this.data, this.isInitialValue);
  factory CurrentUser.create(User data) => CurrentUser._(data, false);

  static const initial = CurrentUser._(null, true);
}
