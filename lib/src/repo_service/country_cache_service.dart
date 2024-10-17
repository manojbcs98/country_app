import 'dart:convert';
import 'package:country_app/barrel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryCacheService implements ICountryCacheService {
  final String _cacheKey = 'cachedCountries';

  @override
  Future<void> cacheCountry(Country country) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getStringList(_cacheKey) ?? [];
    cachedData.add(jsonEncode(country.toJson()));
    await prefs.setStringList(_cacheKey, cachedData);
  }

  @override
  Future<List<Country>?> getCachedCountries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cachedCountryJsonList = prefs.getStringList(_cacheKey);

    // Return null if no cached data is found
    if (cachedCountryJsonList == null || cachedCountryJsonList.isEmpty) {
      return null;
    }

    return _parseCountriesFromJson(cachedCountryJsonList);
  }

  List<Country> _parseCountriesFromJson(List<String> jsonList) {
    final List<Country> countries = [];

    for (String jsonString in jsonList) {
      final country = _decodeCountryJson(jsonString);
      if (country != null) {
        countries.add(country);
      }
    }

    return countries;
  }

  Country? _decodeCountryJson(String jsonString) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return Country.fromJson(jsonMap);
    } catch (e) {
      // Log the error for debugging
      print('Error decoding country JSON: $jsonString - Error: $e');
      return null; // Return null if decoding fails
    }
  }

}
