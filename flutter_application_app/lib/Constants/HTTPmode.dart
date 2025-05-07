enum HTTPMode {
  xml,
  json,
}

extension HTTPModeExtension on HTTPMode {
  String get value {
    switch (this) {
      case HTTPMode.xml:
        return 'xml';
      case HTTPMode.json:
        return 'json';
    }
  }

  static HTTPMode fromString(String value) {
    switch (value) {
      case 'xml':
        return HTTPMode.xml;
      case 'json':
        return HTTPMode.json;
      default:
        throw ArgumentError('Valore HTTPMode non valido: $value');
    }
  }
}