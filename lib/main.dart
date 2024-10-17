import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'barrel.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Country App',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.isDarkTheme
              ? ThemeData.dark()
              : ThemeData.light(),
          home: const SplashScreen(),
        );
      },
    );
  }
}
