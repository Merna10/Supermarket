import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:market/modules/authentication/presentation/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market/modules/home/presentation/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    print('user ${FirebaseAuth.instance.currentUser}');
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market App',
      
      home: StreamBuilder<User?>(
        
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return  HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
