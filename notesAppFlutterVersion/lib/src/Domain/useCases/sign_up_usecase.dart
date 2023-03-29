import 'package:oxidized/oxidized.dart';

import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/repositories/authentication_repository.dart';

class SignUpUsecase {
  //Constructor
  SignUpUsecase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  //Repository
  final AuthenticationRepository _authenticationRepository;

  //Call
  Future<Result<void, AppError>> call(
      {required String email, required String password}) async {
    try {
      await _authenticationRepository.signUp(
        email: email,
        password: password,
      );
      return Result.ok(unit);
    } on Exception catch (e) {
      return Result.err(
          const AppError(type: AppErrorType.authentication, message: "aaa"));
    } catch (_) {
      return Result.err(
          const AppError(type: AppErrorType.authentication, message: "bbb"));
    }
  }
}
