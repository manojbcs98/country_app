import 'package:country_app/barrel.dart';

abstract class ICountryApiService {
  Future<List<dynamic>> fetchCountriesData();
}

abstract class ICountryCacheService {
  Future<void> cacheCountry(Country country);

  Future<List<Country>?> getCachedCountries();
}
