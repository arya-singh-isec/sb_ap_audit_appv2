import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/input_validator.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import 'bloc.dart';

// similar to ViewModel in MVVM
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final InputValidator inputValidator;

  LoginBloc(
      {required this.loginUser,
      required this.logoutUser,
      required this.inputValidator})
      : super(LoginEmpty()) {
    on<Submitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(Submitted event, Emitter<LoginState> emit) async {
    dynamic result;
    if (event.credentials != null) {
      final inputEither = inputValidator.validateCredentials(event.credentials);
      inputEither?.fold((failure) {
        emit(
          LoginError(message: 'Username or password cannot be empty!'),
        );
        emit(LoginEmpty());
      }, (credentials) async {
        emit(LoginLoading());
        result = await loginUser.execute(credentials);
        result?.fold(
          (failure) => emit(LoginError(message: _mapFailureToMessage(failure))),
          (val) =>
              emit(val is User ? LoginSuccess(user: val) : LogoutSuccess()),
        );
      });
    } else {
      emit(LoginLoading());
      result = await logoutUser.execute();
      result?.fold(
        (failure) => emit(LoginError(message: _mapFailureToMessage(failure))),
        (val) => emit(val is User ? LoginSuccess(user: val) : LogoutSuccess()),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return (failure as ServerFailure).message;
      case LocalFailure _:
        return 'Local Error';
      default:
        return 'Unexpected Error';
    }
  }
}
