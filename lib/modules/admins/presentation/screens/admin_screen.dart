import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/modules/admins/logic/bloc/admin_bloc.dart';
import 'package:market/modules/authentication/data/models/user.dart';
import 'package:market/shared/widgets/drawer.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger FetchAdmins when the screen is loaded
    context.read<AdminBloc>().add(FetchAdmins());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management'),
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminLoadedList) {
            if (state.admins.isEmpty) {
              return const Center(child: Text('No admins found'));
            }
            return ListView.builder(
              itemCount: state.admins.length,
              itemBuilder: (context, index) {
                final admin = state.admins[index];
                return ListTile(
                  title: Text(admin.email),
                  subtitle: Text(admin.role),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'update') {
                        _showUpdateDialog(context, admin);
                      } else if (value == 'delete') {
                        context.read<AdminBloc>().add(DeleteAdmin(admin));
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'update',
                        child: Text('Update'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is AdminOperationFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No admins found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAdminDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, Users admin) {
    final TextEditingController nameController =
        TextEditingController(text: admin.userName);
    final TextEditingController emailController =
        TextEditingController(text: admin.email);
    final TextEditingController roleController =
        TextEditingController(text: admin.role);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final updatedAdmin = Users(
                  userName: nameController.text,
                  id: admin.id,
                  email: emailController.text,
                  role: roleController.text,
                  phoneNumber: admin.phoneNumber,
                );
                context.read<AdminBloc>().add(UpdateAdmin(updatedAdmin));
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAdminDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final role = roleController.text.trim();
                final name = nameController.text.trim();

                if (email.isNotEmpty && role.isNotEmpty && name.isNotEmpty) {
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: '12345678',
                    );

                    if (userCredential.user != null) {
                      final newAdmin = Users(
                        userName: name,
                        id: userCredential.user!.uid,
                        email: email,
                        role: role,
                        phoneNumber: '1111111111',
                      );

                      context.read<AdminBloc>().add(AddAdmin(newAdmin));
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add admin: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
