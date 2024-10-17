import 'package:flutter/material.dart';
import 'package:country_app/barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CountryListView extends StatelessWidget {
  const CountryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountryCubit(
          CountryService(CountryApiService(), CountryCacheService()))
        ..loadCachedCountries() // Load cached countries on init
        ..loadCountries(), // Load countries
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Countries'),
          actions: [
            IconButton(
              icon: Icon(
                Provider.of<ThemeNotifier>(context).isDarkTheme
                    ? Icons.wb_sunny
                    : Icons.nights_stay,
              ),
              onPressed: () {
                Provider.of<ThemeNotifier>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ],
        ),
        body: BlocBuilder<CountryCubit, CountryState>(
          builder: (context, state) {
            if (state is CountryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CountryError) {
              return Center(child: Text(state.message)); // Show error message
            } else if (state is CountryLoaded) {
              if (state.countries.isEmpty) {
                return Center(child: Text('No countries available.'));
              }
              return Scrollbar(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.countries.length,
                  itemBuilder: (context, index) {
                    return CountryTile(country: state.countries[index]);
                  },
                ),
              );
            }
            return Center(child: Text('No countries available.'));
          },
        ),
      ),
    );
  }
}
