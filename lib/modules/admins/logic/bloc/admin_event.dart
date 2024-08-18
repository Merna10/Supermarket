part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class FetchAdmins extends AdminEvent {}

class AdminsLoaded extends AdminEvent {
  final List<Users> admins;

  const AdminsLoaded({required this.admins});

  @override
  List<Object> get props => [admins];
}

class AddAdmin extends AdminEvent {
  final Users admin;

  const AddAdmin(this.admin);

  @override
  List<Object> get props => [admin];
}

class UpdateAdmin extends AdminEvent {
  final Users admin;

  const UpdateAdmin(this.admin);

  @override
  List<Object> get props => [admin];
}

class DeleteAdmin extends AdminEvent {
  final Users user;

  const DeleteAdmin(this.user);

  @override
  List<Object> get props => [user];
}

class CheckIfSuperAdmin extends AdminEvent {
  final String userId;

  const CheckIfSuperAdmin(this.userId);

  @override
  List<Object> get props => [userId];
}

class AdminError extends AdminEvent {
  final String error;

  const AdminError({required this.error});

  @override
  List<Object> get props => [error];
}
