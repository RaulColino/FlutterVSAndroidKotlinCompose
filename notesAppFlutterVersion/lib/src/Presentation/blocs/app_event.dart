part of 'app_bloc.dart';

//The AppEvent has two subclasses:

//AppUserChanged which notifies the bloc that the current user has changed.
//AppLogoutRequested which notifies the bloc that the current user has requested to be logged out.

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}


class AppLogoutRequested extends AppEvent {}


class AppUserChanged extends AppEvent {
  @visibleForTesting
  const AppUserChanged(this.user);

  final AuthUser user;

  @override
  List<Object> get props => [user];
}