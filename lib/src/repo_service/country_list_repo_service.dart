import 'package:country_app/barrel.dart';


import '../../barrel.dart';
import '../services/country_api_service_interface.dart';

class CountryService {
  final ICountryApiService _apiService;
  final ICountryCacheService cacheService;

  CountryService(this._apiService, this.cacheService);

  Future<List<Country>> fetchCountries() async {
    List<Country> countries = [];

    try {
      final List<dynamic> countryData = await _apiService.fetchCountriesData();

      for (var data in countryData) {
        final country = Country.fromJson(data);
        countries.add(country);
        await cacheService.cacheCountry(country);
      }
    } catch (e) {
      throw Exception('Error fetching countries: $e');
    }

    return countries;
  }
}
