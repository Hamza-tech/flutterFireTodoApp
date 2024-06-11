import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/notes_model.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({'id': _auth.currentUser!.uid, email: email});
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> AddNote(String subtitle, String title, int image,
    {DateTime? selectedDate, TimeOfDay? selectedTime}) async {
  try {
    var uuid = Uuid().v4();
    DateTime now = DateTime.now();

    // Default to current date and time if not provided
    selectedDate ??= now;
    selectedTime ??= TimeOfDay(hour: now.hour, minute: now.minute);

    // Combine selectedDate and selectedTime into a single DateTime object
    DateTime dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .doc(uuid)
        .set({
      'id': uuid,
      'subtitle': subtitle,
      'title': title,
      'isDone': false,
      'image': image,
      'date': dateTime, // Store as ISO 8601 string if present
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });
    return true;
  } catch (e) {
    print(e); // Add this line to print the error message
    return false; // Changed to false to indicate failure
  }
}

  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data);
        String time;
        DateTime date = DateTime.parse(data['date']);
        DateTime createdAt = DateTime.parse(data['created_at']);
        DateTime updatedAt = DateTime.parse(data['updated_at']);


        // Handle the 'date' field
        if (data['date'] != null) {
          date = DateTime.parse(data['date']);
        } else {
          date = '' as DateTime; // Handle the case where date is not provided
          time = '';
        }
        time = '${date.hour}:${date.minute}';
        return Note(data['id'], data['subtitle'], data['title'], time,
            data['image'], data['isDone'], date,createdAt,updatedAt,);
      }).toList();
      print(notesList);
      return notesList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('notes')
        .orderBy('updated_at', descending: true) // Order by updated_at
        .snapshots();
  } 

  Future<bool> isDone(String uuid, bool isDone) async {
    try {
      DateTime now = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDone': isDone,'updated_at': now.toIso8601String()});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> Update_Note(
  String uuid, int image, String title, String subtitle,
  {DateTime? selectedDate, TimeOfDay? selectedTime}) async {
  try {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(
      selectedDate!.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime!.hour,
      selectedTime.minute,
    );

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .doc(uuid)
        .update({
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'date': dateTime.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

  Future<bool> delete_note(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
