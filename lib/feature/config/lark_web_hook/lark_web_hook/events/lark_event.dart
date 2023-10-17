import 'package:equatable/equatable.dart';

class LarkEvent extends Equatable {
  const LarkEvent();

  @override
  List<Object?> get props => [];
}

class LarkGetListEvent extends LarkEvent {
  final bool isRefresh;
  const LarkGetListEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class LarkUpdateStatusEvent extends LarkEvent {
  final Map<String, dynamic> param;
  const LarkUpdateStatusEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class LarkUpdateDataEvent extends LarkEvent {
  final Map<String, dynamic> param;
  const LarkUpdateDataEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class RemoveEvent extends LarkEvent {
  final String id;
  const RemoveEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class LarkInsertEvent extends LarkEvent {
  final Map<String, dynamic> param;
  const LarkInsertEvent({required this.param});

  @override
  List<Object?> get props => [param];
}
