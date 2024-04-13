import 'package:equatable/equatable.dart';

import '../../../../../models/DTO/response_message_dto.dart';
import '../../../../../models/DTO/web_hook_dto.dart';

class LarkState extends Equatable {
  const LarkState();

  @override
  List<Object?> get props => [];
}

class LarkInitialState extends LarkState {}

class LarkLoadingState extends LarkState {}

class LarkLoadingListState extends LarkState {}

class LarkGetListSuccessfulState extends LarkState {
  final List<WebHookDTO> list;
  final bool isRefresh;
  const LarkGetListSuccessfulState(
      {required this.list, this.isRefresh = false});

  @override
  List<Object?> get props => [list];
}

class UpdateStatusSuccessfulState extends LarkState {}

class UpdateStatusFailedState extends LarkState {
  final ResponseMessageDTO dto;
  const UpdateStatusFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class UpdateDataSuccessfulState extends LarkState {}

class UpdateDataFailedState extends LarkState {
  final ResponseMessageDTO dto;
  const UpdateDataFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class RemoveSuccessfulState extends LarkState {}

class RemoveFailedState extends LarkState {
  final ResponseMessageDTO dto;
  const RemoveFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class InsertSuccessfulState extends LarkState {}

class InsertFailedState extends LarkState {
  final ResponseMessageDTO dto;

  const InsertFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class FailedState extends LarkState {
  final ResponseMessageDTO dto;

  const FailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
