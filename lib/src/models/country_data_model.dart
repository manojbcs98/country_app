class Country {
  final String commonName;
  final String officialName;
  final String currencyName;
  final String currencyCode;
  final String flagUrl;
  final String symbol;
  final String region;

  Country({
    required this.commonName,
    required this.officialName,
    required this.currencyName,
    required this.currencyCode,
    required this.flagUrl,
    required this.symbol,
    required this.region,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    try {
      return Country(
        commonName: _getStringValue(json['name'], 'common'),
        officialName: _getStringValue(json['name'], 'official'),
        currencyName: _getCurrencyValue(json['currencies'], 'name'),
        currencyCode: _getCurrencyCode(json['currencies']),
        flagUrl: json['flags']['png'] ?? '',
        symbol: _getCurrencyValue(json['currencies'], 'symbol'),
        region: json['region'] ?? 'N/A',
      );
    } catch (e) {
      print('Error parsing Country: ${e.toString()}');
      throw Exception('Failed to parse Country: ${e.toString()}');
    }
  }

  static String _getStringValue(Map<String, dynamic> json, String key) {
    return json[key] ?? 'N/A';
  }

  static String _getCurrencyValue(
      Map<String, dynamic>? currencies, String key) {
    if (currencies != null && currencies.isNotEmpty) {
      final firstCurrency = currencies.values.first;
      if (firstCurrency is Map<String, dynamic> && firstCurrency[key] != null) {
        return firstCurrency[key];
      }
    }

    return 'N/A';
  }

  static String _getCurrencyCode(Map<String, dynamic>? currencies) {
    if (currencies != null && currencies.isNotEmpty) {
      return currencies.keys.first;
    }
    return 'N/A';
  }
}
