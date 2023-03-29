import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:memshelf/src/Domain/repositories/authentication_repository.dart';
import 'package:memshelf/src/Domain/repositories/storage_repository.dart';
import 'package:memshelf/src/Presentation/blocs/app_bloc.dart';
import 'package:memshelf/src/Presentation/blocs/storage_user_cubit.dart';
import 'package:memshelf/src/Presentation/utils/routing/routes.dart';
import 'package:memshelf/src/Presentation/utils/theme/app_theme.dart';
import 'package:memshelf/src/Presentation/views/screens/login_screen.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required StorageRepository storageRepository,
  })  : _authenticationRepository = authenticationRepository,
        _storageRepository = storageRepository,
        super(key: key);

  //Repositories
  final AuthenticationRepository _authenticationRepository;
  final StorageRepository _storageRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => StorageUserCubit(
              storageRepository: _storageRepository,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "memshelf",
      theme: AppTheme.theme(),
      // routes: Routes.routeList,
      // home: Scaffold(
      //   body: LoginScreen(),
      // ),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
