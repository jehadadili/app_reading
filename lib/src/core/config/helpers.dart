import 'package:cloud_firestore/cloud_firestore.dart';

dynamic testDocuments(QueryDocumentSnapshot<dynamic> documentsData, String key,
    dynamic replacement) {
  if (documentsData.data().containsKey(key)) {
    if (documentsData[key] != null) {
      return documentsData[key];
    } else {
      return replacement;
    }
  } else if (!documentsData.data().containsKey(key)) {
    return replacement;
  }
}