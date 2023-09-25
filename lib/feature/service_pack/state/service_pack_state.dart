import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/response_message_dto.dart';
import 'package:vietqr_admin/models/service_pack_dto.dart';

class ServicePackState extends Equatable {
  const ServicePackState();

  @override
  List<Object?> get props => [];
}

class ServicePackInitialState extends ServicePackState {}

class ServicePackLoadingState extends ServicePackState {}

class ServicePackLoadingLoadMoreState extends ServicePackState {}

class ServicePackGetListSuccessState extends ServicePackState {
  final List<ServicePackDTO> result;
  final bool initPage;
  final bool isLoadMore;
  const ServicePackGetListSuccessState(
      {required this.result, this.initPage = false, this.isLoadMore = false});

  @override
  List<Object?> get props => [result];
}

class ServicePackInsertSuccessState extends ServicePackState {}

class ServicePackInsertFailsState extends ServicePackState {
  final ResponseMessageDTO dto;

  const ServicePackInsertFailsState({required this.dto});
  @override
  List<Object?> get props => [dto];
}
