import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_academy/model/category_model.dart';

class FireStoreCategory {
  final CollectionReference _categoryCollectionRef =
      FirebaseFirestore.instance.collection('Categories');

  Future<void> addCategoryToFirestore(CategoryModel category) async {
    return await _categoryCollectionRef.doc(category.categoryId).set(
          category.toJson(),
        );
  }

  Future<DocumentSnapshot> getCurrentCategory(String cid) async {
    return await _categoryCollectionRef.doc(cid).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() {
    return _categoryCollectionRef.firestore
        .collection('Categories')
        .snapshots();
  }

  Future<void> updateCategoryInfo({
    required String key,
    required dynamic value,
    required String categoryId,
  }) async {
    return await _categoryCollectionRef.doc(categoryId).update({
      key: value,
    });
  }

  Future<void> deleteCategory(String mid) async {
    return await _categoryCollectionRef.doc(mid).delete();
  }
}
