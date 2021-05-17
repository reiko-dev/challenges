import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/view/pages/main/main_page.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
  addControllers();
}

addControllers() {
  Get.put(DrawingController(), permanent: true);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
