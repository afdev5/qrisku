import 'package:flutter/material.dart';
import 'package:qrisku/bloc/convert_qris/qris_bloc.dart';
import 'package:qrisku/bloc/default_qris/default_qris_bloc.dart';
import 'package:qrisku/service/object_box.dart';
import 'package:qrisku/ui/screens/home_screen.dart';
import 'package:get/get.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var objectBox = await ObjectBox.init();
  Get.put(objectBox);
  Get.put(QrisBloc());
  Get.put(DefaultQrisBloc());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QrisKu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
