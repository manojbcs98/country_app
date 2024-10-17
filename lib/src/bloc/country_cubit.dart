import 'package:bloc/bloc.dart';
import 'package:country_app/barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final CountryService _countryService;

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
        emit(CountryLoaded(cachedCountries)); // Emit loaded cached countries
      }
    } catch (e) {
      emit(CountryError('Error loading cached countries: $e'));
    }
  }
}
