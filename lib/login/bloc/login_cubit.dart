import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(const LoginState());

  final AuthRepository _authRepo;

  Future<void> loginWithGoogle() async {
    _login(_authRepo.loginWithGoogle());
  }

  Future<void> loginWithFacebook() async {
    _login(_authRepo.loginWithFacebook());
  }

  Future<void> loginWithFirebase() async {
    _login(_authRepo.loginWithFirebase());
  }

  Future<void> _login(Future<void> loginFuture) async {
    emit(state.copyWith(status: LoginStatus.loginInProgress));
    try {
      await loginFuture;
      emit(state.copyWith(status: LoginStatus.loginSuccess));
    } on Exception {
      emit(state.copyWith(status: LoginStatus.loginFailure));
    } on NoSuchMethodError {
      emit(state.copyWith(status: LoginStatus.initial));
    }
  }
}
