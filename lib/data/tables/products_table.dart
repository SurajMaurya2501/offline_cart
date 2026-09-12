import 'dart:convert';
import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}

// ProductsTable Table (Stores catalog fetched from dummyjson)
class ProductsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  RealColumn get price => real()();
  RealColumn get discountPercentage => real().nullable()();
  RealColumn get rating => real().nullable()();
  IntColumn get stock => integer()();
  TextColumn get brand => text().nullable()();
  TextColumn get thumbnail => text()();
  TextColumn get images => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}
