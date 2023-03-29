import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memshelf/firebase_options.dart';
import 'package:memshelf/src/Data/firebaseAuth/firebase_authentication_repository.dart';
import 'package:memshelf/src/Data/firebaseStorage/firebase_storage.dart';
import 'package:memshelf/src/Domain/repositories/authentication_repository.dart';
import 'package:memshelf/src/Domain/repositories/storage_repository.dart';
import 'package:memshelf/src/Presentation/blocs/bloc_observer.dart';
import 'package:memshelf/src/app.dart';

Future<void> main() {
  return BlocOverrides.runZoned(

    () async {

      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      //Note: We're injecting a single instance of AuthenticationRepository into the App
      //and it is an explicit constructor dependency.
      final AuthenticationRepository authenticationRepository = FirebaseAuthenticationRepository();
      final StorageRepository storageRepository = FirebaseStorageRepository(); 
      await authenticationRepository.user.first;
      runApp(App(
        authenticationRepository: authenticationRepository,
        storageRepository: storageRepository,
      ));      
    },

    blocObserver: AppBlocObserver(),
    
  );
}
