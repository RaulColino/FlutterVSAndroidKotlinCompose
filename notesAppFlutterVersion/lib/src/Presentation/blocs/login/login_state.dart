import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../utils/form_input/email.dart';
import '../../utils/form_input/password.dart';

//The LoginState consists of an Email, Password, and FormzStatus. 
//The Email and Password models extend FormzInput from the formz package.
class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [email, password, status];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}