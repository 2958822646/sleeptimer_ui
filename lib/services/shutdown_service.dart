import 'dart:io';
import 'package:flutter/material.dart';

/// 关机指令
/// [second] 关机时间间隔，单位秒
/// 默认值为0，立即关机
Future<void> shutdown() async {
  try {
    await Process.run('shutdown', ['/s', '/t', '0']);
  } catch (e) {
    debugPrint("关机指令异常:$e");
  }
}

/// 取消 关机/重启 指令
Future<void> cancelShutdown() async {
  try {
    await Process.run('shutdown', ['/a']);
  } catch (e) {
    debugPrint("取消异常:$e");
  }
}

/// 重启指令
/// [second] 重启时间间隔，单位秒
/// 默认值为0，立即重启
Future<void> restart() async {
  try {
    await Process.run('shutdown', ['/r', '/t', '0']);
  } catch (e) {
    debugPrint("重启指令异常:$e");
  }
}

/// 休眠指令
/// 默认值为0，立即休眠
Future<void> sleep() async {
  try {
    await Process.run('rundll32.exe', [
      'powrprof.dll,SetSuspendState',
      '0,1,0',
    ]);
  } catch (e) {
    debugPrint("休眠执行异常:$e");
  }
}

/// 锁定指令
/// 默认值为0，立即锁定
Future<void> lock() async {
  try {
    await Process.run('rundll32.exe', ['user32.dll,LockWorkStation']);
  } catch (e) {
    debugPrint("锁定执行异常:$e");
  }
}
