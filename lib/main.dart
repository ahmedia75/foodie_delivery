import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodie_delivery/config/app_config.dart';
import 'package:foodie_delivery/provider/notification_provider.dart';
import 'package:foodie_delivery/provider/theme_provider.dart';
import 'package:foodie_delivery/provider/force_update_provider.dart';
import 'package:foodie_delivery/services/notification_service.dart';
import 'package:foodie_delivery/view/notification_list_page.dart';
import 'package:foodie_delivery/widgets/force_update_wrapper.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';
import 'controller/order_controller.dart';
import 'networking/api_service.dart';
import 'view/login_screen.dart';
import 'view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize notification service
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => ApiService(
            baseUrl: ApiConfig.baseUrl,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginController(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderController(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = NotificationProvider();
            // Initialize the provider after creation
            provider.initialize();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ForceUpdateProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ahmedia Delivery Agents',
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            // Override text scale factor to prevent device font size changes from affecting the app
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(
                    1.0,
                  ), // Force text scale to 1.0 (default size)
                ),
                child: child!,
              );
            },
            home: const ForceUpdateWrapper(
              child: SplashScreen(),
            ),
            routes: {
              '/notifications': (context) => const NotificationListPage(),
            },
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final loginController = context.read<LoginController>();
      final isLoggedIn = await loginController.checkLoginStatus();

      print("Login status check - Is logged in: $isLoggedIn");
      print("User data in controller: ${loginController.user?.toJson()}");

      if (!mounted) return;

      if (isLoggedIn && loginController.user != null) {
        print("Navigating to HomeScreen");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const ForceUpdateWrapper(
                    child: HomeScreen(),
                  )),
          (route) => false,
        );
      } else {
        print("Navigating to LoginScreen");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error in splash screen: $e');
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
