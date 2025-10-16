import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;

  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.fullName);
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
    _loadUser();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('fullName') ?? widget.user.fullName;
      usernameController.text = prefs.getString('username') ?? widget.user.username;
      emailController.text = prefs.getString('email') ?? widget.user.email;
      profileImagePath = prefs.getString('profileImage');
    });
  }

  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', nameController.text);
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    if (profileImagePath != null) {
      await prefs.setString('profileImage', profileImagePath!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan disimpan!')),
    );

    // kembalikan User yang diperbarui ke HomeScreen
    User updatedUser = User(
      fullName: nameController.text,
      username: usernameController.text,
      email: emailController.text,
      password: widget.user.password,
    );
    Navigator.pop(context, updatedUser);
  }

  void _pickImage() {
    // sementara dummy
    setState(() {
      profileImagePath = null; // bisa diganti dengan ImagePicker
    });
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.indigo.shade100,
                  backgroundImage: profileImagePath != null ? AssetImage(profileImagePath!) : null,
                  child: profileImagePath == null
                      ? Icon(Icons.account_circle, size: 80, color: Colors.indigo.shade600)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Tap avatar to change photo', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              _buildTextField('Name', nameController),
              _buildTextField('Username', usernameController),
              _buildTextField('Email', emailController),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Logout, pindah ke LoginScreen
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
