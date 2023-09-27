import 'package:equatable/equatable.dart';

class ActiveFeeEvent extends Equatable {
  const ActiveFeeEvent();

  @override
  List<Object?> get props => [];
}

class ActiveFeeGetListEvent extends ActiveFeeEvent {
  final bool initPage;
  final bool isLoadMore;

  const ActiveFeeGetListEvent({this.initPage = false, this.isLoadMore = false});

  @override
  List<Object?> get props => [initPage, isLoadMore];
}
