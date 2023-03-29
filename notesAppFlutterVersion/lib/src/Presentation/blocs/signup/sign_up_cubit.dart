import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/useCases/sign_up_usecase.dart';
import 'package:memshelf/src/Presentation/utils/form_input/confirmed_password.dart';
import 'package:memshelf/src/Presentation/utils/form_input/email.dart';
import 'package:memshelf/src/Presentation/utils/form_input/password.dart';

part 'sign_up_state.dart';

//The SignUpCubit manages the state of the SignUpForm and communicates 
//with the AuthenticationRepository in order to create new user accounts.

//The SignUpCubit is extremely similar to the LoginCubit with the main
//exception being it exposes an API to submit the form as opposed to login.

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUpUsecase) : super(const SignUpState());

  final SignUpUsecase _signUpUsecase;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          password,
          confirmedPassword,
        ]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _signUpUsecase(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on AppError catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
