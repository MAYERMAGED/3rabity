import 'package:abatiy/Classes/ShoppingCart.dart';
import 'package:abatiy/Classes/User.dart';
import 'package:abatiy/pages/Login.dart';
import 'package:abatiy/pages/Service%20Provider/providerRoute.dart';
import 'package:abatiy/pages/admin/adminRoute.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Classes/Favorites.dart';
import 'pages/RoutingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ShoppingCart>(
          create: (context) => ShoppingCart(),
        ),
        ChangeNotifierProvider<Favorites>(
          create: (context) => Favorites(),
        ),
      ],
      child: Myapp(),
    ),
  );
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

late Widget _homeWidget = const Center(
  child: CircularProgressIndicator(),
);

Future<void> getuserType() async {
  final SharedPreferences inAppUser = await SharedPreferences.getInstance();

  if (inAppUser.getBool('rememberme') == true) {
    print('yes');
    nowUser = await CurrentUser().getUserData();
    _homeWidget = arabity();
    switch (inAppUser.get('type')) {
      case "user":
        _homeWidget = userRouting();
        break;
      case "admin":
        _homeWidget = adminRoute();
        break;
      case "provider":
        _homeWidget = providerRoute();
        break;
    }
  } else {
    FirebaseAuth.instance.signOut();
    // GoogleSignIn().disconnect();
    _homeWidget = arabity();
  }
}

class _MyappState extends State<Myapp> {
  @override
  void initState() {
    super.initState();
    getuserType().then((_) {
      getHomeWidget();
      setState(() {});
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  Widget getHomeWidget() {
    return _homeWidget;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        backgroundColor: Colors.white,
        splash: 'assets/image/logo.png',
        splashIconSize: 50,
        splashTransition: SplashTransition.slideTransition,
        nextScreen: getHomeWidget(),
      ),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.orangeAccent, centerTitle: true),
          textTheme: const TextTheme(
              headline1: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ))),
    );
    throw UnimplementedError();
  }
}
