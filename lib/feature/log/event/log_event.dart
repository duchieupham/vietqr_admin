import 'package:equatable/equatable.dart';

class LogEvent extends Equatable {
  const LogEvent();

  @override
  List<Object?> get props => [];
}

class LogGetListEvent extends LogEvent {
  final String date;
  const LogGetListEvent({required this.date});

  @override
  List<Object?> get props => [date];
}
