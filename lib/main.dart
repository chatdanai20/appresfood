import 'package:flutter_k/Providers/discount.dart';
import 'package:flutter_k/Providers/providerMenu.dart';
import 'package:flutter_k/export.dart';

Future<void> _messagingHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messagingHandler);
  await initializeDateFormatting('th', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return searchProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return promotionProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return menuProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return PaymentProvider();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.promptTextTheme(),
        ),
        title: 'Flutter',
        routes: AppRoute.all,
        home: const AuthHome(),
      ),
    );
  }
}
