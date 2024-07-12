// lib/bloc/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}
