import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';

class NewConnectState extends Equatable {
  const NewConnectState();

  @override
  List<Object?> get props => [];
}

class NewConnectInitialState extends NewConnectState {}

class NewConnectLoadingState extends NewConnectState {}

class NewConnectGetTokenLoadingState extends NewConnectState {}

class NewConnectGetPassLoadingState extends NewConnectState {}

class AddCustomerLoadingState extends NewConnectState {}

class GetTokenSuccessfulState extends NewConnectState {
  final ResponseMessageDTO dto;
  const GetTokenSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetTokenFailedState extends NewConnectState {
  final ResponseMessageDTO dto;
  const GetTokenFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetPassSystemSuccessfulState extends NewConnectState {
  final ResponseMessageDTO dto;
  const GetPassSystemSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetPassSystemFailedState extends NewConnectState {
  final ResponseMessageDTO dto;
  const GetPassSystemFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class AddCustomerSuccessfulState extends NewConnectState {
  final ResponseMessageDTO dto;
  const AddCustomerSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class AddCustomerFailedState extends NewConnectState {
  final ResponseMessageDTO dto;
  const AddCustomerFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
