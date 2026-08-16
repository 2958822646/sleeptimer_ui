import 'dart:async';
import 'dart:ui';

class CountdownTimer {
  final int totalSeconds; // 总秒数
  Timer? _timer;
  int _current = 0;

  // 回调监听
  final VoidCallback? onStart;
  final void Function(int remainSeconds)? onTick; // 每秒回调剩余秒数
  final VoidCallback? onFinish; // 倒计时正常结束
  final VoidCallback? onCancel; // 手动取消

  CountdownTimer({
    required this.totalSeconds,
    this.onStart,
    this.onTick,
    this.onFinish,
    this.onCancel,
  });

  /// 启动倒计时
  void start() {
    if (_timer != null) return;
    _current = totalSeconds;
    onStart?.call();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _current--;
      onTick?.call(_current);

      if (_current <= 0) {
        stop();
        onFinish?.call();
      }
    });
  }

  /// 手动取消/停止
  void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      if (_current > 0) {
        // 还没跑完，属于手动取消
        onCancel?.call();
      }
    }
  }

  bool get isRunning => _timer != null;
  int get remainSeconds => _current;
}