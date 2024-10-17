import 'package:country_app/barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MultiProvider(providers: [
                    BlocProvider(
                      create: (context) => CountryCubit(
                        CountryService(
                            CountryApiService(), CountryCacheService()),
                      )
                        ..loadCachedCountries()
                        ..loadCountries(),
                    ),
                  ], child: const CountryListView())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
        "assets/splash_lottie.json",
        height: MediaQuery.of(context).size.height * 1,
        animate: true,
      ),
    );
  }
}
