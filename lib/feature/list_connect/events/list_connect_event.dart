import 'package:equatable/equatable.dart';

class ListConnectEvent extends Equatable {
  const ListConnectEvent();

  @override
  List<Object?> get props => [];
}

class ListConnectGetListEvent extends ListConnectEvent {}

class ListConnectUpdateStatusEvent extends ListConnectEvent {
  final Map<String, dynamic> param;
  const ListConnectUpdateStatusEvent({required this.param});

  @override
  List<Object?> get props => [param];
}
