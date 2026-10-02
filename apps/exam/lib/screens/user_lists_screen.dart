import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/user.dart';
import 'login_screen.dart';

class UserListsScreen extends StatefulWidget {
  const UserListsScreen({super.key});

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

                return ListTile(
                  leading: Icon(
                    isActive ? Icons.check_circle : Icons.check_circle_outline,
                    color: isActive ? Colors.blue : Colors.grey,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
