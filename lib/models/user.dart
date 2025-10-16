class User {
  String fullName;
  String username;
  String email;
  String password;

  User({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });
}


final List<User> users = [
  User(
    fullName: 'Siska Nuri Aprilia',
    email: 'aprilias878@gmail.com',
    username: 'aprilias878',
    password: '123',
  ),
];