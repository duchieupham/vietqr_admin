import 'package:equatable/equatable.dart';

class ListConnectEvent extends Equatable {
  const ListConnectEvent();

  @override
  List<Object?> get props => [];
}

class ListConnectGetListEvent extends ListConnectEvent {
  final int type;
  final int page;
  final int size;
  final String value;
  final int typeSearch;
  const ListConnectGetListEvent(
      {required this.type,
      required this.page,
      required this.size,
      required this.value,
      required this.typeSearch});

  @override
  List<Object?> get props => [type, page, value, size, typeSearch];
}

class ListConnectUpdateStatusEvent extends ListConnectEvent {
  final Map<String, dynamic> param;
  final int type;
  final int page;
  final int size;
  final String value;
  final int typeSearch;
  const ListConnectUpdateStatusEvent(
      {required this.param,
      required this.type,
      required this.page,
      required this.size,
      required this.value,
      required this.typeSearch});

  @override
  List<Object?> get props => [param, type, page, value, size, typeSearch];
}
