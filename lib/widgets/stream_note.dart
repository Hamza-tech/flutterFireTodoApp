import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/firestore.dart';
import 'package:todo_app/widgets/task_widgets.dart';

class Stream_note extends StatelessWidget {
  bool done;
  Stream_note(this.done,{super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore_Datasource().stream(done),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final notesList = Firestore_Datasource().getNotes(snapshot);
        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(), // Allow scrolling
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                Firestore_Datasource().delete_note(note.id);
              },
              child: Task_Widget(note),
            );
          },
          itemCount: notesList.length,
        );
      },
    );
  }
}
