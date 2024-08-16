class CourseModel {
  String? courseId;
  String? categoryId;
  String? doctorId;
  String? title;
  String? description;
  String? image;
  double? price;
  bool? active;

  CourseModel({
    this.courseId,
    this.categoryId,
    this.doctorId,
    this.title,
    this.description,
    this.image,
    this.price,
    this.active = false,
  });

  CourseModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    courseId = map['courseId'];
    categoryId = map['categoryId'];
    doctorId = map['doctorId'];
    title = map['title'];
    description = map['description'];
    image = map['image'];
    price = map['price'];
    active = map['active'];
  }

  toJson() {
    return {
      'courseId': courseId,
      'categoryId': categoryId,
      'doctorId': doctorId,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'active': active,
    };
  }
}
