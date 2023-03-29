import 'package:equatable/equatable.dart';

import 'package:memshelf/src/Domain/entities/note.dart';

//StorageUser. Used for data storage of AuthUser.
class StorageUser extends Equatable {

  //Properties
  final String id;
  final String name;
  final List<Note> notes;

  //Constructor
  const StorageUser({
    required this.id,
    required this.name,
    required this.notes,
  });

  // Equatable
  @override
  List<Object?> get props => [id];


  //Generated serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'notes': notes.map((x) => x.toMap()).toList(),
    };
  }

  factory StorageUser.fromMap(Map<String, dynamic> map) {
    return StorageUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      notes: List<Note>.from(map['notes']?.map((x) => Note.fromMap(x))),
    );
  }

  StorageUser copyWith({
    String? id,
    String? name,
    List<Note>? notes,
  }) {
    return StorageUser(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
    );
  }
}
