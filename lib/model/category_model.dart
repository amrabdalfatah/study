class CategoryModel {
  String? categoryId;
  String? title;
  String? image;

  CategoryModel({
    this.categoryId,
    this.title,
    this.image,
  });

  CategoryModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    categoryId = map['categoryId'];
    title = map['title'];
    image = map['image'];
  }

  toJson() {
    return {
      'categoryId': categoryId,
      'title': title,
      'image': image,
    };
  }
}
