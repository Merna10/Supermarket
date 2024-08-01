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
  final String userName;
  final String phoneNumber;
  final String location;

  const AuthSignUpEvent({required this.email, required this.password, required this.userName, required this.phoneNumber, required this.location});

  @override
  List<Object> get props => [email, password, userName, phoneNumber, location];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}
