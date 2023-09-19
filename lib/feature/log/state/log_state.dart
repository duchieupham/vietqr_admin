import 'package:equatable/equatable.dart';

class LogState extends Equatable {
  const LogState();

  @override
  List<Object?> get props => [];
}

class LogInitialState extends LogState {}

class LogLoadingState extends LogState {}

class GetLogSuccessState extends LogState {
  final List<String> result;
  const GetLogSuccessState({required this.result});

  @override
  List<Object?> get props => [result];
}
