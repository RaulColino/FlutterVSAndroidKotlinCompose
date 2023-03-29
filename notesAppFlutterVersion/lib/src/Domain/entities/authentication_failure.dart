
//Authentication failure
abstract class AuthenticationFailure implements Exception{}

//SignUp failure
class SignUpWithEmailAndPasswordFailure implements AuthenticationFailure{
}

//Login with email and password failure
class LogInWithEmailAndPasswordFailure implements AuthenticationFailure{
}

//Login with Google failure
class LogInWithGoogleFailure implements AuthenticationFailure{
}

//Thrown during the logout process if a failure occurs
class LogOutFailure implements AuthenticationFailure {
}
