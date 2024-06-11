import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';

import 'package:todo_app/auth/main_page.dart';
import 'package:todo_app/flutter_local_notification.dart';
import 'package:todo_app/screens/add_note_screen.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/widgets/task_widgets.dart';

import 'timezone_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TimeZoneHelper.initialize();
  NotificationHelper.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Main_Page(),
    );
  }
}
