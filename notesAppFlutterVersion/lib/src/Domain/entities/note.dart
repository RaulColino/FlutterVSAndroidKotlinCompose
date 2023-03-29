import 'dart:convert';

import 'package:equatable/equatable.dart';

class Note extends Equatable {
  //Properties
  final String category;
  final String color;
  final String title;
  final String body;

  //Constructor
  const Note({
    required this.category,
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [category, title, body];


  //Firebase serialization
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'color': color,
      'title': title,
      'body': body,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      category: map['category'] ?? '',
      color: map['color'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
    );
  }
}
