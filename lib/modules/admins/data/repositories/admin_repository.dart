import 'package:market/modules/admins/data/services/admin_service.dart';
import 'package:market/modules/authentication/data/models/user.dart';

class AdminRepository {
  final AdminService _adminService;

  AdminRepository({AdminService? adminService})
      : _adminService = adminService ?? AdminService();

  Stream<List<Users>> fetchAdmins() {
    return _adminService.fetchAdmins();
  }

  Future<void> addAdmin(Users admin) async {
    try {
      await _adminService.addAdmin(admin);
    } catch (e) {
      throw Exception('Failed to add admin: $e');
    }
  }

  Future<void> updateAdmin(Users admin) async {
    try {
      await _adminService.updateAdmin(admin);
    } catch (e) {
      throw Exception('Failed to update admin: $e');
    }
  }

  Future<void> deleteAdmin(Users admin) async {
    try {
      await _adminService.deleteAdmin(admin);
    } catch (e) {
      throw Exception('Failed to delete admin: $e');
    }
  }

  Future<bool> isSuperAdmin(String userId) {
    try {
      return _adminService.isSuperAdmin(userId);
    } catch (e) {
      throw Exception('Failed to check admin role: $e');
    }
  }

  Future<Users?> getAdminByEmail(String email) async {
    try {
      return _adminService.getAdminByEmail(email);
    } catch (e) {
      print('Error fetching admin: $e');
      return null;
    }
  }

 
}
