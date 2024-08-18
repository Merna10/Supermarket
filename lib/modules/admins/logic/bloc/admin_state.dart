part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}


class AdminOperationSuccess extends AdminState {}

class AdminOperationFailure extends AdminState {
  final String message;

  const AdminOperationFailure(this.message);

  @override
  List<Object> get props => [message];

  get error => null;
}

class AdminLoadedList extends AdminState {
  final List<Users> admins;

  const AdminLoadedList({required this.admins});

  @override
  List<Object> get props => [admins];
}

class SuperAdminAccessGranted extends AdminState {}

class SuperAdminAccessDenied extends AdminState {}

class AdminErrors extends AdminState {
  final String error;

  const AdminErrors({required this.error});

  @override
  List<Object> get props => [error];
}
