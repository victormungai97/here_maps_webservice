import 'package:equatable/equatable.dart';

class Category extends Equatable {
  /// Identifier number for an associated category.
  final String id;

  /// Name of the place category in the result item language.
  final String name;

  /// Whether or not it is a primary category. This field is visible only when the value is `true`.
  final bool primary;

  const Category._({this.id = "", this.name = "", this.primary = false});

  factory Category({
    String? id = "",
    String? name = "",
    bool? primary = false,
  }) =>
      Category._(id: id ?? "", name: name ?? "", primary: primary ?? false);

  factory Category.fromJson(Map<String?, dynamic>? json) => Category(
        id: json?["id"] ?? "",
        name: json?["name"] ?? "",
        primary: json?["primary"] ?? false,
      );

  static Map<String, dynamic>? toJson(Category? category) => {
        "id": category?.id ?? "",
        "name": category?.name ?? "",
        "primary": category?.primary ?? false,
      };

  @override
  List<Object?> get props => [id, name, primary];
}
