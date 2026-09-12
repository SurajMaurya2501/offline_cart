extension SafeParsing on Map<String, dynamic> {
  String parseString(String key, {String fallback = ''}) {
    final value = this[key];
    if (value == null) return fallback;
    return value.toString();
  }

  int parseInt(String key, {int fallback = 0}) {
    final value = this[key];
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  double parseDouble(String key, {double fallback = 0.0}) {
    final value = this[key];
    if (value == null) return fallback;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  bool parseBool(String key, {bool fallback = false}) {
    final value = this[key];
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    if (value is int) return value == 1;
    return fallback;
  }

  List<T> parseList<T>(
    String key,
    T Function(Map<String, dynamic> json) parser, {
    List<T> fallback = const [],
  }) {
    final value = this[key];
    if (value == null || value is! List) return fallback;
    try {
      return value
          .whereType<Map<String, dynamic>>()
          .map((item) => parser(item))
          .toList();
    } catch (_) {
      return fallback;
    }
  }

  List<String> parseStringList(String key, {List<String> fallback = const []}) {
    final value = this[key];
    if (value == null || value is! List) return fallback;
    try {
      return value.map((item) => item.toString()).toList();
    } catch (_) {
      return fallback;
    }
  }

  Map<String, dynamic> parseMap(
    String key, {
    Map<String, dynamic> fallback = const {},
  }) {
    final value = this[key];
    if (value == null || value is! Map) return fallback;
    return Map<String, dynamic>.from(value);
  }
}
