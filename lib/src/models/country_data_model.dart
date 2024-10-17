class Country {
  final String commonName;
  final String officialName;
  final String currencyName;
  final String flagUrl;
  final String symbol;

  Country({
    required this.commonName,
    required this.officialName,
    required this.currencyName,
    required this.flagUrl,
    required this.symbol,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    try {
      return Country(
        commonName: _getStringValue(json['name'], 'common'),
        officialName: _getStringValue(json['name'], 'official'),
        currencyName: _getCurrencyValue(json['currencies'], 'name'),
        flagUrl: json['flags']['png'] ?? '',
        symbol: _getCurrencyValue(json['currencies'], 'symbol'),
      );
    } catch (e) {
      print('Error parsing Country: ${e.toString()}');
      throw Exception('Failed to parse Country');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {
        'common': commonName,
        'official': officialName,
      },
      'currencies': {
        'name': currencyName,
        'symbol': symbol,
      },
      'flags': {
        'png': flagUrl,
      },
    };
  }

  static String _getStringValue(Map<String, dynamic> json, String key) {
    return json[key] ?? 'N/A';
  }

  static String _getCurrencyValue(Map<String, dynamic>? currencies, String key) {
    if (currencies != null && currencies.isNotEmpty) {
      // Attempt to get the currency value directly by key
      if (currencies.containsKey(key)) {
        return currencies[key];
      }

      // If not found, check the first currency in the map
      final firstCurrency = currencies.values.first;
      if (firstCurrency is Map<String, dynamic> && firstCurrency[key] != null) {
        return firstCurrency[key];
      }
    }

    return 'N/A'; // Default return value if no valid currency found
  }

}
