import 'package:app_memo/di.dart';

import 'package:app_memo/pages/home/home_page.dart';
import 'package:app_memo/pages/login/login_page.dart';
import 'package:app_memo/pages/splash_screen.dart';
import 'package:app_memo/services/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'domain/current_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await MemosDI.init();

  // trasparent status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(
    Provider(
      create: (context) => AuthState(),
      child: MemosApp(),
    ),
  );
}

class MemosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: FirebaseAuth.instance
          .authStateChanges()
          .map((user) => CurrentUser.create(user)),
      initialData: CurrentUser.initial,
      child: Consumer<CurrentUser>(
        builder: (context, user, _) {
          return MaterialApp(
            title: 'App memo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: user.isInitialValue
                ? SplashScreen()
                : user.data != null
                    ? HomePage()
                    : LoginPage(),
          );
        },
      ),
    );
  }
}
