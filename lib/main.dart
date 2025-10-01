import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:keytype/core/navigation/Navigation.dart';
import 'package:keytype/core/navigation/Routes.dart';
import 'package:keytype/core/storage/local_storage_manager.dart';
import 'package:keytype/core/services/keyboard_service.dart';
import 'package:keytype/core/services/ai_keyboard_service.dart';

import 'core/helper/base_brain.dart';
import 'core/init/app_init.dart';

void main() async {
  await _beforeRunApp();

  runApp(const MyApp());
}

Future<void> _beforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load();
  final init = AppInit();
  init.useCaseRepository();
  final storage = await LocalStorageManager.getInstance();
  BaseBrain.accessToken = storage.getToken() ?? '';
  BaseBrain.refreshToken = storage.getRefreshToken() ?? '';

  // Initialize keyboard service for receiving text from custom keyboard
  KeyboardService.initialize();
  
  // Initialize AI keyboard service for handling AI requests
  AIKeyboardService.initialize();

  // Set up keyboard service callbacks for AI integration
  // _setupKeyboardServiceCallbacks();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return GetMaterialApp(
      title: 'Keyboard AI',
      enableLog: true,
      defaultTransition: Transition.fadeIn,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
          textTheme: TextTheme(
              bodySmall: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          )),
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: Locale('en', ''),
      supportedLocales: [
        Locale('en', ''),
        Locale('fa', ''),
      ],
      builder: (context, child) {
        child = Center(
            child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: child,
        ));
        child = botToastBuilder(context, child);
        return SafeArea(child: child);
      },
      transitionDuration: Duration(milliseconds: 400),
      getPages: Nav.allNav,
      initialRoute: Routes.splash,
    );
  }
}
