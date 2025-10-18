import '../models/user.dart';

class UserManager {
  static List<User> getAllUsers() => users;

  static void addUser(User user) {
    users.add(user);
  }

  static User? login(String email, String password) {
    try {
      return users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  static bool emailExists(String email) {
    return users.any((user) => user.email == email);
  }

  static bool usernameExists(String username) {
    return users.any((user) => user.username == username);
  }
}
