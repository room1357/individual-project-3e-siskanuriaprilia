class User {
  final String fullName;
  final String email;
  final String username;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
  });
}

final List<User> users = [
  User(
    fullName: 'Siska Nuri Aprilia',
    email: 'aprilias878@gmail.com',
    username: 'siska',
    password: '123',
  ),
];