import 'package:bazaar_api/bazaar_api.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:salone_bazaar/routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await const BazaarApi().initializeApi(isDebug: false);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme(context: context, brightness: Brightness.light).theme(),
      routerConfig: const AppRouter().router,
      debugShowCheckedModeBanner: false,
    );
  }
}
