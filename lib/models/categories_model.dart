import 'package:equatable/equatable.dart';
import 'package:offline_cart/core/extensions/safe_parsing.dart';

class CategoryModel extends Equatable {
  final String slug;
  final String name;
  final String url;

  const CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json.parseString('slug'),
      name: json.parseString('name'),
      url: json.parseString('url'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name, 'url': url};
  }

  static List<CategoryModel> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .whereType<Map<String, dynamic>>()
        .map((item) => CategoryModel.fromJson(item))
        .toList();
  }

  @override
  List<Object?> get props => [slug, name, url];
}
