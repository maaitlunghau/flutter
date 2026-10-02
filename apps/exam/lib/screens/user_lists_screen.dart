import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/user.dart';
import 'login_screen.dart';

class UserListsScreen extends StatefulWidget {
  final User? currentUser;

  const UserListsScreen({super.key, this.currentUser});

  @override
  State<UserListsScreen> createState() => _UserListsScreenState();
}

class _UserListsScreenState extends State<UserListsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final list = await _dbHelper.getAllUsers();
    setState(() {
      _users = list;
      _isLoading = false;
    });
  }

  Future<void> _toggleUserStatus(User user, bool value) async {
    if (user.id == null) return;

    final isSelf =
        widget.currentUser != null && user.id == widget.currentUser!.id;

    if (isSelf && !value) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Text('Warning'),
            ],
          ),
          content: const Text(
            'You are about to deactivate your own account!\n\n'
            'If you proceed, your account will be locked, you will be logged out immediately, '
            'and you will not be able to log in again until reactivated. Do you want to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Deactivate & Logout'),
            ),
          ],
        ),
      );

      if (confirm != true) {
        return;
      }

      await _dbHelper.updateActiveStatus(user.id!, 0);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your account has been deactivated. You have been logged out.',
          ),
          backgroundColor: Colors.orange,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final newStatus = value ? 1 : 0;
    await _dbHelper.updateActiveStatus(user.id!, newStatus);
    await _loadUsers();
  }

  void _handleLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(
              child: Text(
                'No users found',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final isActive = user.isActive == 1;
                final isSelf =
                    widget.currentUser != null &&
                    user.id == widget.currentUser!.id;

                return ListTile(
                  leading: Icon(
                    isActive ? Icons.check_circle : Icons.check_circle_outline,
                    color: isActive ? Colors.blue : Colors.grey,
                  ),
                  title: Row(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isSelf) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    isActive ? 'Active' : 'UnActive',
                    style: TextStyle(
                      fontSize: 13,
                      color: isActive ? Colors.green : Colors.grey.shade600,
                    ),
                  ),
                  trailing: Switch(
                    value: isActive,
                    onChanged: (bool value) => _toggleUserStatus(user, value),
                  ),
                );
              },
            ),
    );
  }
}
