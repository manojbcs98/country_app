import 'package:country_app/barrel.dart';
class CountryService {
  final ICountryApiService _apiService;

  CountryService(this._apiService);

  Future<List<Country>> fetchCountries() async {
    List<Country> countries = [];

    try {
      final List<dynamic> countryData = await _apiService.fetchCountriesData();

      for (var data in countryData) {
        final country = Country.fromJson(data);
        countries.add(country);

      }
    } catch (e) {
      throw Exception('Error fetching countries: $e');
    }

    return countries;
  }
}
