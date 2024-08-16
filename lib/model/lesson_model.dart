class LessonModel {
  String? lessonId;
  String? title;
  String? description;
  String? pathFile;

  LessonModel({
    this.lessonId,
    this.title,
    this.description,
    this.pathFile,
  });

  LessonModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    lessonId = map['lessonId'];
    title = map['title'];
    description = map['description'];
    pathFile = map['pathFile'];
  }

  toJson() {
    return {
      'lessonId': lessonId,
      'title': title,
      'description': description,
      'pathFile': pathFile,
    };
  }
}
