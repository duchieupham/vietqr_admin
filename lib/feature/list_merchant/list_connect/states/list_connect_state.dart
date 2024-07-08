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
  final MetaData? metaData;

  const ListConnectSuccessfulState({required this.dto, this.metaData});

  @override
  List<Object?> get props => [dto, metaData];
}

class ListConnectFailedState extends ListConnectState {}
