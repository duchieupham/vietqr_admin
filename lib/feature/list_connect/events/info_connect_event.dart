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
