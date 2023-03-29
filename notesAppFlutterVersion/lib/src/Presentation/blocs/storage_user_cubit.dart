import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';

import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/entities/auth_user.dart';
import 'package:memshelf/src/Domain/entities/note.dart';
import 'package:memshelf/src/Domain/entities/storage_user.dart';
import 'package:memshelf/src/Domain/repositories/storage_repository.dart';

class StorageUserCubit extends Cubit<StorageUserState> {
  //Properties
  final StorageRepository _storageRepository;
  late StorageUser _storageUser;

  //Constructor
   StorageUserCubit({
    required storageRepository,
  }) : _storageRepository = storageRepository, 
       super(StorageUserLoadingState());


  //Get user data
  Future<void> getUserData(AuthUser authUser) async {
    emit(StorageUserLoadingState());
    Result<StorageUser,AppError> storageUserResult = await _storageRepository.getUserData(authUser);
    storageUserResult.when(
      ok: (storageUsr) {
        _storageUser = storageUsr;
        emit(StorageUserReadyState(_storageUser));
      },
      err: (e) {
        emit(StorageUserErrorState(e));
      },
    );
  }

  //Save user data
  Future<void> saveUserData(AuthUser authUser, String id, String name, List<Note> notes) async {

    _storageUser =  StorageUser(id: id, name: name, notes: notes);

    emit(StorageUserReadyState(_storageUser, isSaving: true));

    // Just for testing we add a 3 seconds delay: This allows to see the loading in the home page
    await Future.delayed(Duration(seconds: 3));

    await _storageRepository.saveUserData(_storageUser, authUser);

    emit(StorageUserReadyState(_storageUser));
  }
}

abstract class StorageUserState extends Equatable {
  var user;

  @override
  List<Object?> get props => [];
}

class StorageUserLoadingState extends StorageUserState {}

class StorageUserErrorState extends StorageUserState {
  final AppError appErr;
  StorageUserErrorState(this.appErr);
}

class StorageUserReadyState extends StorageUserState {
  final StorageUser user;
  final isSaving;

  StorageUserReadyState(this.user, {this.isSaving = false});

  @override
  List<Object?> get props => [user, isSaving];
}
