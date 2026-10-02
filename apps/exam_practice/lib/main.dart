import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/contact.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primarySlate = Color(0xFF5B7181);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primarySlate,
          primary: primarySlate,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primarySlate,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primarySlate,
          foregroundColor: Colors.white,
        ),
      ),
      home: const ContactsScreen(),
    );
  }
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final list = await _dbHelper.getAllContacts();
    setState(() {
      _contacts = list;
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(Contact contact) async {
    if (contact.id == null) return;
    final newFavorite = contact.isFavorite == 1 ? 0 : 1;
    await _dbHelper.updateFavorite(contact.id!, newFavorite);
    await _loadContacts();
  }

  void _showAddContactDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _AddContactDialog(
        onAdd: (name, phone, email) async {
          final newContact = Contact(
            name: name,
            phone: phone,
            email: email,
            isFavorite: 0,
          );
          await _dbHelper.insertContact(newContact);
          await _loadContacts();
        },
      ),
    );
  }

  Widget _buildContactList(List<Contact> contacts) {
    if (contacts.isEmpty) {
      return const Center(
        child: Text(
          'No contacts found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isFav = contact.isFavorite == 1;

        return ListTile(
          title: Text(
            contact.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            contact.phone,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          trailing: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.grey,
            ),
            onPressed: () => _toggleFavorite(contact),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteContacts = _contacts.where((c) => c.isFavorite == 1).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildContactList(_contacts),
                  _buildContactList(favoriteContacts),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddContactDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _AddContactDialog extends StatefulWidget {
  final Future<void> Function(String name, String phone, String email) onAdd;

  const _AddContactDialog({required this.onAdd});

  @override
  State<_AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<_AddContactDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Contact',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final name = _nameController.text.trim();
            final phone = _phoneController.text.trim();
            final email = _emailController.text.trim();

            if (name.isEmpty || phone.isEmpty) {
              return;
            }

            Navigator.pop(context);
            await widget.onAdd(name, phone, email);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
