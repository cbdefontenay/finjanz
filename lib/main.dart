import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/theme.dart';
import 'theme/theme_provider.dart';
import 'theme/custom_themes.dart';
import 'providers/expense_provider.dart';
import 'pages/navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: const FinjanzApp(),
    ),
  );
}

class FinjanzApp extends StatelessWidget {
  const FinjanzApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    const textTheme = TextTheme();
    final baseTheme = MaterialTheme(textTheme);

    final standardAppBarTheme = const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    ThemeData? currentTheme;
    ThemeData? currentDarkTheme;
    ThemeMode currentThemeMode = ThemeMode.system;

    switch (themeProvider.appTheme) {
      case AppTheme.system:
        currentTheme = baseTheme.light().copyWith(appBarTheme: standardAppBarTheme);
        currentDarkTheme = baseTheme.dark().copyWith(appBarTheme: standardAppBarTheme);
        currentThemeMode = ThemeMode.system;
        break;
      case AppTheme.light:
        currentTheme = baseTheme.light().copyWith(appBarTheme: standardAppBarTheme);
        currentThemeMode = ThemeMode.light;
        break;
      case AppTheme.dark:
        currentDarkTheme = baseTheme.dark().copyWith(appBarTheme: standardAppBarTheme);
        currentThemeMode = ThemeMode.dark;
        break;
      case AppTheme.ocean:
        currentTheme = CustomThemes.oceanTheme();
        currentThemeMode = ThemeMode.light; // Force light mode to use currentTheme
        break;
      case AppTheme.forest:
        currentTheme = CustomThemes.forestTheme();
        currentThemeMode = ThemeMode.light; // Force light mode to use currentTheme
        break;
    }

    return MaterialApp(
      title: 'Finjanz',
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      darkTheme: currentDarkTheme,
      themeMode: currentThemeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('de', 'DE')],
      home: const NavigationPage(),
    );
  }
}
