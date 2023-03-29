import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:memshelf/src/Domain/repositories/authentication_repository.dart';
import 'package:memshelf/src/Domain/useCases/login_with_credentials_usecase.dart';
import 'package:memshelf/src/Domain/useCases/login_with_google_usecase.dart';
import 'package:memshelf/src/Presentation/blocs/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memshelf/src/Presentation/blocs/login/login_state.dart';
import 'package:memshelf/src/Presentation/views/screens/recover_password_screen.dart';
import 'package:memshelf/src/Presentation/views/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  //static String routeName = "/sign_in";
  static Page page() => const MaterialPage<void>(child: LoginScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (_) => LoginCubit(
          LoginWithCredentialsUsecase(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
          LoginWithGoogleUseCase(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 68),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 68),
                _EmailInput(),
                const SizedBox(height: 8),
                _PasswordInput(),
                const SizedBox(height: 1),
                _RememberMeAndForgotPassword(),
                const SizedBox(height: 2),
                _LoginButton(),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Text("OR"),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 16),
                _GoogleLoginButton(),
                const SizedBox(height: 36),
                _SignUpTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            labelText: "Email",
            hintText: "Enter your email",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always,
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            labelText: 'Password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
            hintText: "Enter your password",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //suffixIcon: SvgPicture.asset("assets/icons/lock.svg"),
          ),
        );
      },
    );
  }
}

class _RememberMeAndForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Checkbox(
          value: true,
          activeColor: Colors.orange,
          onChanged: null,
        ),
        const Text("Remember me"),
        const Spacer(),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, RecoverPasswordScreen.routeName),
          child: const Text(
            "Forgot Password",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          primary: const Color.fromARGB(255, 242, 243, 250),
        ),
        icon: SvgPicture.asset("assets/icons/google-icon.svg"),
        onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
        label: const Text(
          'SIGN IN WITH GOOGLE',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _SignUpTextRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
