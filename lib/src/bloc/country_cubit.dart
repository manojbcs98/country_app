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

  void filterCountries(String searchTerm) {
    if (_allCountries.isEmpty) return;

    final filteredCountries = _allCountries.where((country) {
      return country.commonName
          .toLowerCase()
          .contains(searchTerm.toLowerCase());
    }).toList();

    emit(CountryLoaded(
        filteredCountries));
  }

  void sortCountries(SortOrder sortOrder) {
    if (_allCountries.isEmpty) return;

    if (sortOrder == SortOrder.aToZ) {
      _allCountries.sort((a, b) => a.commonName.compareTo(b.commonName));
    } else if (sortOrder == SortOrder.zToA) {
      _allCountries.sort((a, b) => b.commonName.compareTo(a.commonName));
    } else {
      _allCountries.sort((a, b) => a.region.compareTo(b.region));
    }
    emit(CountryLoaded(
        _allCountries));
  }
}
