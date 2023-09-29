import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/models/annual_fee_dto.dart';

class AnnualFeeState extends Equatable {
  const AnnualFeeState();

  @override
  List<Object?> get props => [];
}

class AnnualFeeInitialState extends AnnualFeeState {}

class AnnualFeeLoadingState extends AnnualFeeState {}

class AnnualFeeGetListSuccessState extends AnnualFeeState {
  final List<AnnualFeeDTO> result;
  final bool initPage;
  final bool isLoadMore;
  const AnnualFeeGetListSuccessState(
      {required this.result, this.initPage = false, this.isLoadMore = false});

  @override
  List<Object?> get props => [result];
}
