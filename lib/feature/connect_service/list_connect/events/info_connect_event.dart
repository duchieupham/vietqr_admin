import 'package:equatable/equatable.dart';

class InfoConnectEvent extends Equatable {
  const InfoConnectEvent();

  @override
  List<Object?> get props => [];
}

class GetInfoConnectEvent extends InfoConnectEvent {
  final String id;
  final String platform;
  const GetInfoConnectEvent({required this.platform, required this.id});

  @override
  List<Object?> get props => [id, platform];
}

class GetListBankEvent extends InfoConnectEvent {
  final String id;
  const GetListBankEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddBankConnectEvent extends InfoConnectEvent {
  final Map<String, dynamic> param;
  const AddBankConnectEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class RemoveBankConnectEvent extends InfoConnectEvent {
  final Map<String, dynamic> param;
  const RemoveBankConnectEvent({required this.param});

  @override
  List<Object?> get props => [param];
}

class UpdateMerchantEvent extends InfoConnectEvent {
  final Map<String, dynamic> param;
  const UpdateMerchantEvent({required this.param});

  @override
  List<Object?> get props => [param];
}
