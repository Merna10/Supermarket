import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market/modules/admins/data/repositories/admin_repository.dart';
import 'package:market/modules/authentication/data/models/user.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;
  StreamSubscription<List<Users>>? _adminSubscription;

  AdminBloc(this._adminRepository) : super(AdminInitial()) {
    on<FetchAdmins>(_onFetchAdmins);
    on<AddAdmin>(_onAddAdmin);
    on<UpdateAdmin>(_onUpdateAdmin);
    on<DeleteAdmin>(_onDeleteAdmin);
    on<CheckIfSuperAdmin>(_onCheckIfSuperAdmin);
    on<AdminError>(_onAdminError);
    on<AdminsLoaded>(_onAdminsLoaded);
  }

  void _onFetchAdmins(FetchAdmins event, Emitter<AdminState> emit) {
    emit(AdminLoading());
    _adminSubscription?.cancel();

    _adminSubscription = _adminRepository.fetchAdmins().listen(
      (admins) {
        add(AdminsLoaded(admins: admins));
      },
      onError: (error) { 
        add(AdminError(error: error.toString()));
      },
    );
  }

  void _onAdminsLoaded(AdminsLoaded event, Emitter<AdminState> emit) {
    emit(AdminLoadedList(admins: event.admins));
  }

  Future<void> _onAddAdmin(AddAdmin event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _adminRepository.addAdmin(event.admin);
      add(FetchAdmins());
      emit(AdminOperationSuccess());
    } catch (e) {
      emit(AdminOperationFailure('Failed to add admin: $e'));
    }
  }

  Future<void> _onUpdateAdmin(
      UpdateAdmin event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _adminRepository.updateAdmin(event.admin);
      add(FetchAdmins()); 
      emit(AdminOperationSuccess());
    } catch (e) {
      emit(AdminOperationFailure('Failed to update admin: $e'));
    }
  }

  Future<void> _onDeleteAdmin(
      DeleteAdmin event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _adminRepository.deleteAdmin(event.user);
      add(FetchAdmins()); 
      emit(AdminOperationSuccess());
    } catch (e) {
      emit(AdminOperationFailure('Failed to delete admin: $e'));
    }
  }

  Future<void> _onCheckIfSuperAdmin(
      CheckIfSuperAdmin event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final isSuperAdmin = await _adminRepository.isSuperAdmin(event.userId);
      if (isSuperAdmin) {
        emit(SuperAdminAccessGranted());
      } else {
        emit(SuperAdminAccessDenied());
      }
    } catch (e) {
      emit(AdminOperationFailure('Failed to check super admin status: $e'));
    }
  }

  void _onAdminError(AdminError event, Emitter<AdminState> emit) {
    emit(AdminOperationFailure(event.error));
  }

  @override
  Future<void> close() {
    _adminSubscription?.cancel();
    return super.close();
  }
}
