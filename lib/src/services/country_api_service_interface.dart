import 'package:country_app/barrel.dart';

abstract class ICountryApiService {
  Future<List<dynamic>> fetchCountriesData();
}