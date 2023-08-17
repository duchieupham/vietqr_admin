import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEventLogin extends LoginEvent {
  final Map<String, dynamic> param;
  const LoginEventLogin({required this.param});

  @override
  List<Object?> get props => [param];
}
