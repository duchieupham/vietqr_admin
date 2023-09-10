import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/ecomerce_dto.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';

import '../../../models/api_service_dto.dart';

class InfoConnectState extends Equatable {
  const InfoConnectState();

  @override
  List<Object?> get props => [];
}

class InfoConnectInitialState extends InfoConnectState {}

class InfoConnectLoadingState extends InfoConnectState {}

class InfoApiServiceConnectSuccessfulState extends InfoConnectState {
  final ApiServiceDTO dto;
  const InfoApiServiceConnectSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class InfoEcomerceDTOConnectSuccessfulState extends InfoConnectState {
  final EcomerceDTO dto;
  const InfoEcomerceDTOConnectSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class InfoConnectFailedState extends InfoConnectState {
  final ResponseMessageDTO dto;
  const InfoConnectFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
