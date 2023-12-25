import 'package:equatable/equatable.dart';

class AnnualFeeEvent extends Equatable {
  const AnnualFeeEvent();

  @override
  List<Object?> get props => [];
}

class AnnualFeeGetListEvent extends AnnualFeeEvent {
  final bool initPage;
  final bool isLoadMore;

  const AnnualFeeGetListEvent({this.initPage = false, this.isLoadMore = false});

  @override
  List<Object?> get props => [initPage, isLoadMore];
}
