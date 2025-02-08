import 'package:flutter/material.dart';
import 'second_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User management',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  const HomeScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> users = [];
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLocked = false;

  void addUserAndNavigate() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      users.add({"username": username, "password": password});
      usernameController.clear();
      passwordController.clear();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(users: users, isDarkMode: widget.isDarkMode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: const Text("Main Screen"),
        actions: [
          Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          Switch(value: widget.isDarkMode, onChanged: widget.toggleTheme,activeColor: Colors.blue,
          inactiveThumbColor: Colors.yellow,),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          const SizedBox(height: 20),
            const Text("Welcome to the User Management App!",
              style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 5),
            const Text("Enter your data to continue",
            style: TextStyle(fontSize: 16, color: Colors.grey)),

            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("Lock Input", style: TextStyle(fontSize: 18)),
              value: isLocked,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  isLocked = value;

                });
              },
              secondary: Icon(isLocked ? Icons.lock : Icons.lock_open),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.greenAccent : Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,cursorColor: Colors.black,
                    readOnly: isLocked,style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "User Name",labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    readOnly: isLocked,style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Password",labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.teal,
              ),
              onPressed: isLocked ? null : addUserAndNavigate,
              child: const Text(
                "Go To Second Screen",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
