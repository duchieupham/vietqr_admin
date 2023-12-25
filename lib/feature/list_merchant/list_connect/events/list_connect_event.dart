import 'package:equatable/equatable.dart';

class ListConnectEvent extends Equatable {
  const ListConnectEvent();

  @override
  List<Object?> get props => [];
}

class ListConnectGetListEvent extends ListConnectEvent {
  final int type;
  const ListConnectGetListEvent({required this.type});

  @override
  List<Object?> get props => [type];
}

class ListConnectUpdateStatusEvent extends ListConnectEvent {
  final Map<String, dynamic> param;
  final int type;
  const ListConnectUpdateStatusEvent({required this.param, required this.type});

  @override
  List<Object?> get props => [param, type];
}
