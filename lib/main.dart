import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/myhome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(600, 600),
    minimumSize: Size(600, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false, // 隐藏任务栏
    titleBarStyle: TitleBarStyle.normal, // 隐藏标题栏
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();// 显示窗口
    await windowManager.focus();// 窗口获取焦点
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SleepTimerUI',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}
