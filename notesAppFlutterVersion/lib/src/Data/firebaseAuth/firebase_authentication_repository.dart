import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/repositories/authentication_repository.dart';
import 'package:oxidized/oxidized.dart';

import '../../Domain/entities/auth_user.dart';

//Manages user authentication.
class FirebaseAuthenticationRepository implements AuthenticationRepository {
  
  //Properties
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  //Constructor
  FirebaseAuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();



  //Stream of User which will emit the current user when the authentication state changes.
  //Emits User.empty if the user is not authenticated.
  @override
  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? AuthUser.empty : firebaseUser.toUser;
      //_cache.write(key: userCacheKey, value: user);
      return user;
    });
  }



  //Returns the current cached user.
  // Defaults to User.empty if there is no cached user.
  @override
  AuthUser get currentUser {
    //return _cache.read<User>(key: userCacheKey) ?? User.empty;
    return AuthUser.empty;
  }



  /// Creates a new user with the provided email and password.
  @override
  Future<Result<void, AppError>> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.ok(unit);

    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("signUpFailure: "+e.code);
      return Result.err(AppError(type: AppErrorType.authentication,message: "SignUpWithEmailAndPasswordFailure: " + e.code));
      
    } catch (_) {
      if (kDebugMode) print("signUpFailure: unknown");
      return Result.err(const AppError(type: AppErrorType.authentication,message: "SignUpWithEmailAndPasswordFailure: unknown error"));
    }
  }



  //Signs in with the provided email and password
  @override
  Future<Result<void,AppError>> logInWithEmailAndPassword({required String email,required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.ok(unit);

     } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("logInWithEmailAndPasswordFailure: "+e.code);
      return Result.err(AppError(type: AppErrorType.authentication, message: e.code));

    } catch (_) {
      if (kDebugMode) print("logInWithEmailAndPasswordFailure: unknown");
      return Result.err(const AppError(type: AppErrorType.authentication, message: "logInWithEmailAndPasswordFailure"));
    }
  }



  //Starts the Sign In with Google Flow.
  @override
  Future<Result<void,AppError>> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;

      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      return Result.ok(unit);

    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("LogInWithGoogleFailure: "+e.code);
      return Result.err(AppError(type: AppErrorType.authentication, message: e.code));

    } catch (_) {
      if (kDebugMode) print("LogInWithGoogleFailure: unknown");
      return Result.err(const AppError(type: AppErrorType.authentication, message: "LogInWithGoogleFailure"));
    }
  }



  /// Signs out the current user which will emit
  /// [AuthUser.empty] from the [user] Stream.
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<Result<void,AppError>> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return Result.ok(unit);
     } catch (_) {
      if (kDebugMode) print("logOutFailure");
      return Result.err(const AppError(type: AppErrorType.authentication, message: "logOutFailure"));
    }
  }



  @override
  Future<Result<void,AppError>> recoverPassword() async {
    throw UnimplementedError();
  }
}


extension on firebase_auth.User {
  AuthUser get toUser {
    return AuthUser(id: uid, email: email, name: displayName);
  }
}
