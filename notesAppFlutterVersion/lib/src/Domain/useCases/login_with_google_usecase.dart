import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/repositories/authentication_repository.dart';
import 'package:oxidized/oxidized.dart';

class LoginWithGoogleUseCase {
  //Constructor
  LoginWithGoogleUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  //Repository
  final AuthenticationRepository _authenticationRepository;

  //Call
  Future<Result<void, AppError>> call() async {
    try {
      return await _authenticationRepository.logInWithGoogle();
    } on Exception catch (e) {
      return Result.err(
          const AppError(type: AppErrorType.authentication, message: "aaa"));
    } catch (_) {
      return Result.err(
          const AppError(type: AppErrorType.authentication, message: "bbb"));
    }
  }
}
