import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/useCases/login_with_credentials_usecase.dart';
import 'package:memshelf/src/Domain/useCases/login_with_google_usecase.dart';
import 'package:memshelf/src/Presentation/blocs/login/login_state.dart';

import '../../utils/form_input/email.dart';
import '../../utils/form_input/password.dart';

//The LoginCubit is responsible for managing the LoginState of the form.
//It exposes APIs to logInWithCredentials, logInWithGoogle, as well as
//gets notified when the email/password are updated.

//The LoginCubit has a dependency on the AuthenticationRepository
//in order to sign the user in either via credentials or via google sign in.

//Note: We used a Cubit instead of a Bloc here because the LoginState is fairly
//simple and localized. Even without events, we can still have a fairly good
//sense of what happened just by looking at the changes from one state to
//another and our code is a lot simpler and more concise.
class LoginCubit extends Cubit<LoginState> {

  LoginCubit(this._loginWithCredentialsUsecase, this._loginWithGoogleUseCase) : super(const LoginState());

  final LoginWithCredentialsUsecase _loginWithCredentialsUsecase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;

  //Login with credentials
  Future<void> logInWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _loginWithCredentialsUsecase(
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

  //Login with google
  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _loginWithGoogleUseCase();
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


  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.email, password]),
      ),
    );
  }
}
