import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// User model
///
/// [User.empty]: unauthenticated user.
class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
  });

  factory User.fromFirebaseUser(firebase_auth.User user) =>
      User(id: user.uid, name: user.displayName, email: user.email);

  /// The current user's id.
  final String id;
  final String? email;

  /// The current user's name (display name).
  final String? name;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name];
}
