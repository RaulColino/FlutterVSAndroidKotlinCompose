import 'package:equatable/equatable.dart';

//AuthUser. Used for autentication data.
class AuthUser extends Equatable {
  //Properties
  final String id;
  final String? email;
  final String? name;

  //Constructor
  const AuthUser({
    required this.id,
    this.email,
    this.name,
  });

  /// Empty user which represents an unauthenticated user.
  static const empty = AuthUser(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == AuthUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != AuthUser.empty;

  @override
  List<Object?> get props => [email, id, name];
}
