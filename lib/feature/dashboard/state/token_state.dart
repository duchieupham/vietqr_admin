import 'package:equatable/equatable.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';

class TokenState extends Equatable {
  final String? msg;
  final BlocStatus status;
  final HomeType request;
  final TokenType typeToken;

  const TokenState({
    this.msg,
    this.status = BlocStatus.NONE,
    this.request = HomeType.NONE,
    this.typeToken = TokenType.NONE,
  });

  TokenState copyWith({
    BlocStatus? status,
    String? msg,
    HomeType? request,
    TokenType? typeToken,
  }) {
    return TokenState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      typeToken: typeToken ?? this.typeToken,
    );
  }

  @override
  List<Object?> get props => [
        status,
        msg,
        request,
      ];
}
