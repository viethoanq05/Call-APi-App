import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController companyController;
  late TextEditingController websiteController;

  bool get isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    phoneController = TextEditingController(text: widget.user?.phone ?? '');
    companyController = TextEditingController(text: widget.user?.company ?? '');
    websiteController = TextEditingController(text: widget.user?.website ?? '');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = User(
      id: widget.user?.id ?? '',
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      company: companyController.text,
      website: websiteController.text,
    );

    if (isEdit) {
      await UserService.updateUser(user);
    } else {
      await UserService.addUser(user);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit User" : "Add User"), backgroundColor: Colors.blueAccent,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(nameController, "Name"),
              _buildField(emailController, "Email"),
              _buildField(phoneController, "Phone"),
              _buildField(companyController, "Company"),
              _buildField(websiteController, "Website"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? "Update" : "Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
