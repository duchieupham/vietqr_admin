import 'package:equatable/equatable.dart';

class ServicePackEvent extends Equatable {
  const ServicePackEvent();

  @override
  List<Object?> get props => [];
}

class ServicePackGetListEvent extends ServicePackEvent {
  final bool initPage;
  final bool isLoadMore;

  const ServicePackGetListEvent(
      {this.initPage = false, this.isLoadMore = false});

  @override
  List<Object?> get props => [initPage, isLoadMore];
}

class InsertServicePackEvent extends ServicePackEvent {
  final Map<String, dynamic> param;

  const InsertServicePackEvent({
    required this.param,
  });

  @override
  List<Object?> get props => [param];
}
