// create models of user
// with full name, email, password
class User {
  String fullName;
  String email;
  String username;
  String password;

  User({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
  });
}

//create dummy users
List<User> dummyUsers = [
  User(
    fullName: "Siska Nuri Aprilia", 
    email: "aprilias878@gmail.com",
    username: "Siska",
    password: "123",
  ),
];