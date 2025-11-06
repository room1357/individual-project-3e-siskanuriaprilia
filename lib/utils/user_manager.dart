import '../models/user.dart';

class UserManager {
  // Simulasi database sementara dalam bentuk list
  static List<User> users = [
    User(
      username: 'siska',
      email: 'siska@example.com',
      password: '12345',
      fullName: 'Siska Nuri Aprilia',
    ),
    User(
      username: 'nabilah',
      email: 'nabilah@example.com',
      password: 'abcd',
      fullName: 'Nabilah Putri',
    ),
  ];

  static List<User> getAllUsers() => users;

  // Fungsi untuk menambahkan user baru
  static void addUser(User user) {
    users.add(user); // ✅ perbaikan di sini
  }

  // Fungsi login
  static User? login(String email, String password) {
    try {
      return users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Cek apakah email sudah terdaftar
  static bool emailExists(String email) {
    return users.any((user) => user.email == email);
  }

  // Cek apakah username sudah terdaftar
  static bool usernameExists(String username) {
    return users.any((user) => user.username == username);
  }
}
