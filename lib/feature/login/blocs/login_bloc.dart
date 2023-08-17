import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/feature/login/events/login_event.dart';
import 'package:vietqr_admin/feature/login/repositories/login_repository.dart';
import 'package:vietqr_admin/feature/login/states/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginEventLogin>(_login);
  }
}

const LoginRepository loginRepository = LoginRepository();

void _login(LoginEvent event, Emitter emit) async {
  try {
    if (event is LoginEventLogin) {
      emit(LoginLoadingState());
      bool check = await loginRepository.login(event.param);
      // await userSettingRepository.getGuideWeb(userId)
      if (check) {
        emit(LoginSuccessfulState());
      } else {
        emit(LoginFailedState());
      }
    }
  } catch (e) {
    print('Error at login - LoginBloc: $e');
    emit(LoginFailedState());
  }
}
