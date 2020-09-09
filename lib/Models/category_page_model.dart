import 'package:beda3a/Models/category_model.dart';
import 'package:beda3a/Models/product_model.dart';

class CategoryPageModel {
  int id;
  String name;
  String image;
  int categoryId;
  String createdAt;
  String updatedAt;
  List<Category> categories;
  List<Product> products;

  CategoryPageModel({
    this.id,
    this.name,
    this.image,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.products,
  });

  factory CategoryPageModel.fromJson(Map<String, dynamic> json) =>
      CategoryPageModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        categories: json["category"] == null
            ? null
            : List<Category>.from(
                json["category"].map((x) => Category.fromJson(x))),
        products: json["product"] == null
            ? null
            : List<Product>.from(
                json["product"].map((x) => Product.fromJson(x))),
      );
}
