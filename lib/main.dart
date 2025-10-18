import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/expense_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ExpenseManager.init(); // Load data dulu sebelum runApp
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(), // tetap login dulu
    );
  }
}