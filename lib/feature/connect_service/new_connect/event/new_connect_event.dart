import 'package:equatable/equatable.dart';

class NewConnectEvent extends Equatable {
  const NewConnectEvent();

  @override
  List<Object?> get props => [];
}

class GetTokenEvent extends NewConnectEvent {
  final Map<String, dynamic> param;
  const GetTokenEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class GetPassSystemEvent extends NewConnectEvent {
  final Map<String, dynamic> param;
  const GetPassSystemEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class AddCustomerSyncEvent extends NewConnectEvent {
  final Map<String, dynamic> param;
  const AddCustomerSyncEvent({required this.param});

  @override
  List<Object?> get props => [param];
}
