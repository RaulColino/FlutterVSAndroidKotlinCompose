import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:memshelf/src/Domain/entities/app_error.dart';
import 'package:memshelf/src/Domain/entities/auth_user.dart';
import 'package:memshelf/src/Domain/entities/storage_user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:memshelf/src/Domain/repositories/storage_repository.dart';
import 'package:oxidized/oxidized.dart';

//Manages remote storage of user data
class FirebaseStorageRepository implements StorageRepository{

  //Properties
  final firebase_storage.FirebaseStorage _firebaseStorage;
  final cloud_firestore.FirebaseFirestore _cloudFirestore;

  //Constructor
  FirebaseStorageRepository({
    firebase_storage.FirebaseStorage? firebaseStorage,
    cloud_firestore.FirebaseFirestore? cloudFirestore,
  }) : _firebaseStorage = firebaseStorage ?? firebase_storage.FirebaseStorage.instance,
       _cloudFirestore = cloudFirestore ?? cloud_firestore.FirebaseFirestore.instance;


  //Returns user stored data from Firebase Storage given a AuthUser id
  @override
  Future<Result<StorageUser, AppError>> getUserData(AuthUser authUser) async {
    try {
      final snapshot = await _cloudFirestore.doc('user/${authUser.id}').get();
      if (snapshot.exists) { 
        return  Result.ok(StorageUser.fromMap(snapshot.data()!)); 
      } else {
        //First time user -> we load the first data from this user to Firebase
        StorageUser newUserData = StorageUser(id: authUser.id, name: "unknown", notes: const []);
        saveUserData(newUserData, authUser);
        return Result.ok(newUserData);
      }

    } catch (e) {
      if (kDebugMode) print("Error: FirebaseStorageRepository.getUserData():"+e.toString());
      return Result.err(const AppError(type: AppErrorType.storage, message: "Oops an error happened!"));
    }
  }

  //Save user data to Firebase
  @override
  Future<Result<void, AppError>> saveUserData(StorageUser storageUser, AuthUser authUser) async {
    try{
      final document = _cloudFirestore.doc('user/${authUser.id}');
      await document.set(storageUser.toMap(), SetOptions(merge: true));
      return Result.ok(unit);

    }catch(e) {
      if (kDebugMode) print("Error: FirebaseStorageRepository.saveUserData(): "+e.toString());
      return Result.err(const AppError(type: AppErrorType.storage, message: "Oops an error happened!"));
    }
  }
}
