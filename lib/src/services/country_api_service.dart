import 'package:country_app/barrel.dart';

class CountryApiService implements ICountryApiService {
  final NetworkEngine _networkEngine = NetworkEngine();

  @override
  Future<List<dynamic>> fetchCountriesData() async {
    final dio = _networkEngine.getDio();
    List<dynamic> countryData = [];

    for (String countryName in countryNames) {
      try {
        final response = await dio.get(countryName);

        if (response.statusCode == 200) {
          countryData.add(response.data[0]);
        } else {
          throw Exception('Failed to load country data for $countryName');
        }
      } catch (e) {
        throw Exception('Error fetching data for $countryName: $e');
      }
    }

    return countryData;
  }
}
