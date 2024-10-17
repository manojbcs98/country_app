import 'package:bloc/bloc.dart';
import 'package:country_app/barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final CountryService _countryService;
  List<Country> _allCountries = [];

  CountryCubit(this._countryService) : super(CountryInitial());

  Future<void> loadCountries() async {
    emit(CountryLoading());

    // Attempt to load cached countries first
    await loadCachedCountries();

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(CountryError(
            'No internet connection. Please check your connection.'));
        return; // Exit if there is no internet
      }

      final countries = await _countryService.fetchCountries();
      _allCountries = countries; // Store all countries for future filtering
      emit(CountryLoaded(countries));
    } catch (e) {
      emit(CountryError('Error loading countries: $e'));
    }
  }

  Future<void> loadCachedCountries() async {
    try {
      final cachedCountries =
          await _countryService.cacheService.getCachedCountries();
      if (cachedCountries != null && cachedCountries.isNotEmpty) {
        _allCountries = cachedCountries; // Store cached countries
        emit(CountryLoaded(cachedCountries)); // Emit loaded cached countries
      }
    } catch (e) {
      emit(CountryError('Error loading cached countries: $e'));
    }
  }

  // New method to filter countries based on search term
  void filterCountries(String searchTerm) {
    if (_allCountries.isEmpty) return; // Ensure there are countries to filter

    final filteredCountries = _allCountries.where((country) {
      return country.commonName
          .toLowerCase()
          .contains(searchTerm.toLowerCase());
    }).toList();

    emit(CountryLoaded(
        filteredCountries)); // Emit the new state with filtered countries
  }

  void sortCountries(SortOrder sortOrder) {
    if (_allCountries.isEmpty) return; // Ensure there are countries to sort

    if (sortOrder == SortOrder.aToZ) {
      _allCountries.sort((a, b) => a.commonName.compareTo(b.commonName));
    } else if (sortOrder == SortOrder.zToA) {
      _allCountries.sort((a, b) => b.commonName.compareTo(a.commonName));
    }
    emit(CountryLoaded(
        _allCountries)); // Emit the new state with sorted countries
  }
}
