import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:memshelf/src/Domain/entities/auth_user.dart';
import 'package:memshelf/src/Domain/repositories/authentication_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

//The AppBloc is responsible for managing the global state of the application. It has a dependency on the AuthenticationRepository 
//and subscribes to the user Stream in order to emit new states in response to changes in the current user.
//The AppBloc responds to incoming AppEvents and transforms them into outgoing AppStates. Upon initialization, 
//it immediately subscribes to the user stream from the AuthenticationRepository and adds 
//an AuthenticationUserChanged event internally to process changes in the current user.
//close is overridden in order to handle cancelling the internal StreamSubscription.

class AppBloc extends Bloc<AppEvent, AppState> {
  
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenticationRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );
  }
  
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<AuthUser> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
