import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:component_library/component_library.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'app_routes.dart';
import 'scaffold_with_navbar.dart';

const isDebug = bool.fromEnvironment('DEBUG', defaultValue: true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (isDebug) {
    const host = 'localhost';

    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  final route = const AppRoutes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme(context: context, brightness: Brightness.light).theme(),
      routerConfig: GoRouter(
        initialLocation: PathConstants.productListPath,
        routes: [
          ShellRoute(
              // bottom navigation route
              builder: (_, __, child) => ScaffoldWithNavBar(child: child),
              routes: [
                route.productListRoute,
                route.userCartRoute,
                route.orderListRoute,
                route.userProfileRoute,
              ]),
          route.orderDetailsRoute,
          route.productDetailsRoute,
          route.signInRoute,
          route.signUpRoute,
          // add routes here
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
