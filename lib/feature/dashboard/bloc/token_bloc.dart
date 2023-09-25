import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/feature/dashboard/event/token_event.dart';
import 'package:vietqr_admin/feature/dashboard/res/log_out_repository.dart';
import 'package:vietqr_admin/feature/dashboard/res/token_repository.dart';
import 'package:vietqr_admin/feature/dashboard/state/token_state.dart';

import '../../../commons/utils/log.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenBloc() : super(const TokenState()) {
    on<TokenEventCheckValid>(_checkValidToken);
    on<TokenEventLogout>(_logout);
  }

  void _checkValidToken(TokenEvent event, Emitter emit) async {
    try {
      if (event is TokenEventCheckValid) {
        emit(state.copyWith(status: BlocStatus.NONE, request: HomeType.NONE));
        int check = await tokenRepository.checkValidTokenWeb();
        TokenType type = TokenType.NONE;
        if (check == 0) {
          type = TokenType.InValid;
        } else if (check == 1) {
          type = TokenType.Valid;
        } else if (check == 2) {
          type = TokenType.MainSystem;
        } else if (check == 3) {
          type = TokenType.Internet;
        } else if (check == 4) {
          type = TokenType.Expired;
        }

        emit(state.copyWith(
            status: BlocStatus.NONE, request: HomeType.TOKEN, typeToken: type));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE,
          request: HomeType.TOKEN,
          typeToken: TokenType.InValid));
    }
  }

  void _logout(TokenEvent event, Emitter emit) async {
    try {
      if (event is TokenEventLogout) {
        emit(state.copyWith(status: BlocStatus.NONE, request: HomeType.NONE));
        bool check = await logoutRepository.logout();
        TokenType type = TokenType.NONE;
        if (check) {
          type = TokenType.Logout;
        } else {
          type = TokenType.Logout_failed;
        }

        emit(state.copyWith(
            status: BlocStatus.NONE, request: HomeType.TOKEN, typeToken: type));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE,
          request: HomeType.TOKEN,
          typeToken: TokenType.Logout_failed));
    }
  }
}

TokenRepository tokenRepository = const TokenRepository();
LogoutRepository logoutRepository = const LogoutRepository();
