import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/entities/authentication_failure.dart';
import 'package:memshelf/src/Domain/entities/auth_user.dart';
import 'package:oxidized/oxidized.dart';

abstract class AuthenticationRepository {
  
  Future<Result<void, AppError>> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<void, AppError>> logInWithGoogle();

  Future<Result<void, AppError>> signUp({
    required String email,
    required String password,
  });

  Future<Result<void, AppError>> recoverPassword();

  Future<Result<void, AppError>> logOut();


  //Weird
  
  Stream<AuthUser> get user;

  AuthUser get currentUser;
}
