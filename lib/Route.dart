import 'package:flutter_k/Screens/mapScreen/Map.dart';
import 'package:flutter_k/export.dart';

class AppRoute {
  static const welcome = 'welcome';
  static const register = 'register';
  static const login = 'login';
  static const search = 'search';
  static const cart = 'cart';
  static const user = 'user';
  static const setting = 'setting';
  static const stepact = 'stepAct';
  static const payment = 'payment';
  static const map = 'Map';

  static get all => <String, WidgetBuilder>{
        welcome: (context) => const WelcomeScreen(),
        register: (context) => const RegisterScreen(),
        login: (context) => const LoginScreen(),
        search: (context) => const SearchScreen(email: ''),
        // cart: (context) => const CartScreen(),
        user: (context) => const UserScreen(),
        setting: (context) => const SettingScreen(),
        stepact: (context) => const StepActivity(),
        // payment: (context) => const PaymentScreen(),
        map: (context) => const MapSample(),
      };
}
