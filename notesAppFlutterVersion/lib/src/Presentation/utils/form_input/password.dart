import 'package:formz/formz.dart';

//An Email and Password input model are useful for encapsulating the validation logic 
//and will be used in both the LoginForm and SignUpForm.

//Both input models are made using the formz package and allow us 
//to work with a validated object rather than a primitive type like a String.

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid
}


/// Form input for an password input.
class Password extends FormzInput<String, PasswordValidationError> {

  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }
}
