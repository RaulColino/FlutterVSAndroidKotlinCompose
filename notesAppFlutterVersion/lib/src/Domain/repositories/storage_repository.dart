import 'package:memshelf/src/Domain/entities/auth_user.dart';
import 'package:memshelf/src/Domain/entities/storage_user.dart';
import 'package:oxidized/oxidized.dart';

import '../entities/app_error.dart';

abstract class StorageRepository {

  Future<Result<StorageUser, AppError>> getUserData(AuthUser authUser);

  Future<Result<void, AppError>> saveUserData(StorageUser storageUser, AuthUser authUser);
}
