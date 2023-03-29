import 'package:equatable/equatable.dart';

class AppError extends Equatable {

  final AppErrorType type;
  final String message;

  const AppError({
    required this.type,
    required this.message,}
  );

  @override
  List<Object> get props => [type, message];
}

enum AppErrorType {storage, network, authentication}
