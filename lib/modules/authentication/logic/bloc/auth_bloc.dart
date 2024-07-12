// lib/bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/authentication/data/repositories/authentication_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthCheckStatusEvent>(_onCheckStatus);
  }

  void _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  void _onCheckStatus(AuthCheckStatusEvent event, Emitter<AuthState> emit) {
    _authRepository.user.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}
