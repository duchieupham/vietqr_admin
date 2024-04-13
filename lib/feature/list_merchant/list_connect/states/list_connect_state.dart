import 'package:equatable/equatable.dart';

import '../../../../models/DTO/connect.dto.dart';

class ListConnectState extends Equatable {
  const ListConnectState();

  @override
  List<Object?> get props => [];
}

class ListConnectInitialState extends ListConnectState {}

class ListConnectLoadingState extends ListConnectState {}

class ListConnectSuccessfulState extends ListConnectState {
  final List<ConnectDTO> dto;
  const ListConnectSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class ListConnectFailedState extends ListConnectState {}
