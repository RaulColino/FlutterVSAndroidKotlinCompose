part of 'app_bloc.dart';

//The AppState consists of an AppStatus and a User. Two named constructors 
//are exposed: unauthenticated and authenticated to make it easier to work with.

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = AuthUser.empty,
  });

  const AppState.authenticated(AuthUser user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final AuthUser user;

  @override
  List<Object> get props => [status, user];
}
