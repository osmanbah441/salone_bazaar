import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:component_library/component_library.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'app_routes.dart';
import 'scaffold_with_navbar.dart';

const isDebug = true;

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


//   const fakeProduct = <Product>[
//    
//     Product(
//       category: ProductCategory.accessories,
//       id: '7',
//       isFeatured: true,
//       name: 'Gatsby hat',
//       price: 40,
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/70/200/300',
//     ),
//     Product(
//       category: ProductCategory.accessories,
//       id: '8',
//       isFeatured: true,
//       name: 'Shrug bag',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/80/200/300',
//       price: 198,
//     ),
//     Product(
//       category: ProductCategory.home,
//       id: '9',
//       isFeatured: true,
//       name: 'Gilt desk trio',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/90/200/300',
//       price: 58,
//     ),
//     Product(
//       category: ProductCategory.home,
//       id: '10',
//       isFeatured: false,
//       name: 'Copper wire rack',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/100/200/300',
//       price: 18,
//     ),
//     Product(
//       category: ProductCategory.home,
//       id: '11',
//       isFeatured: false,
//       name: 'Soothe ceramic set',
//       imageUrl: 'https://picsum.photos/id/110/200/300',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       price: 28,
//     ),
//     Product(
//       category: ProductCategory.home,
//       id: '12',
//       isFeatured: false,
//       name: 'Hurrahs tea set',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/120/200/300',
//       price: 34,
//     ),
//   
//     Product(
//       category: ProductCategory.clothing,
//       id: '34',
//       isFeatured: false,
//       name: 'Shoulder rolls tee',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/780/200/300',
//       price: 27,
//     ),
//     Product(
//       category: ProductCategory.clothing,
//       id: '35',
//       isFeatured: false,
//       name: 'Grey slouch tank',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/430/200/300',
//       price: 24,
//     ),
//     Product(
//       category: ProductCategory.clothing,
//       id: '36',
//       isFeatured: false,
//       name: 'Sunshirt dress',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/210/200/300',
//       price: 58,
//     ),
//     Product(
//       category: ProductCategory.clothing,
//       id: '37',
//       isFeatured: true,
//       name: 'Fine lines tee',
//       description:
//           "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
//       imageUrl: 'https://picsum.photos/id/220/200/300',
//       price: 58,
//     ),
//   ];