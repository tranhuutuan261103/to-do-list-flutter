import 'package:to_do_list/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ToDo>> getToDoList() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('todos').get();
      return querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final Map<String, dynamic> data = doc.data();
        return ToDo(
          id: doc.id,
          title: data['title'],
          isCompleted: data['isCompleted'],
        );
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return <ToDo>[];
    }
  }

  Future<ToDo?> addToDoItem(String title) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          await _firestore.collection('todos').add(<String, dynamic>{
        'title': title,
        'isCompleted': false,
      });
      return ToDo(
        id: docRef.id,
        title: title,
        isCompleted: false,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }
}
