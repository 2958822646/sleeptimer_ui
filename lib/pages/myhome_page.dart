import 'package:flutter/material.dart';
import '../widgets/times_card.dart';
import '../utils/countdown_timer.dart';
import '../services/shutdown_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _ctimeController = TextEditingController(text: '0');
  TextEditingController _mtimeController = TextEditingController(text: '0');
  TextEditingController _stimeController = TextEditingController(text: '0');

  int _selecteTime = 0;
  int _selecteAction = 0;
  bool _isStart = false;

  final timePresets = const {
    '60 秒': 60,
    '5 分钟': 5 * 60,
    '15 分钟': 15 * 60,
    '30 分钟': 30 * 60,
    '1 小时': 3600,
    '2 小时': 7200,
  };

  /// 执行操作
  Future<void> _executeAction() async {
    if (_mtimeController.text.isEmpty ||
        _stimeController.text.isEmpty ||
        _ctimeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌时间不能为空")));
      debugPrint("时间不能为空");
      return;
    }
    if (_mtimeController.text == '0' &&
        _stimeController.text == '0' &&
        _ctimeController.text == '0') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌时间不能为0秒")));
      debugPrint("时间不能为空");
      return;
    }
    if (_isStart) {
      _cancelTask();
      return;
    }
    _selecteTime =
        int.parse(_mtimeController.text) * 60 +
        int.parse(_stimeController.text) +
        int.parse(_ctimeController.text) * 3600;

    if (_selecteAction == 0) {
      _startTask(_selecteTime, shutdown);
    } else if (_selecteAction == 1) {
      _startTask(_selecteTime, restart);
    } else if (_selecteAction == 2) {
      _startTask(_selecteTime, sleep);
    } else if (_selecteAction == 3) {
      _startTask(_selecteTime, lock);
    }
  }

  /// 倒计时
  /// [second] 倒计时时间间隔，单位秒
  CountdownTimer? _countdown;
  int _remain = 0;

  Future<void> _startTask(int second, Future<void> Function() fun) async {
    _countdown = CountdownTimer(
      totalSeconds: second,
      onStart: () {
        setState(() {
          _isStart = true;
          debugPrint("倒计时开始");
        });
      },
      onTick: (remain) {
        setState(() {
          _remain = remain;
        });
      },
      onFinish: () async {
        setState(() {
          _isStart = false;
          debugPrint("倒计时完成");
        });
        await fun();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("✅倒计时完成")));
      },
      onCancel: () {
        setState(() {
          _isStart = false;
          debugPrint("倒计时被手动取消");
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌倒计时被手动取消")));
      },
    );
    _countdown!.start();
  }

  void _cancelTask() {
    _countdown?.stop();
    setState(() {
      _isStart = false;
      debugPrint("倒计时被取消");
    });
  }

  @override
  void initState() {
    super.initState();
    _ctimeController.text = '0';
    _mtimeController.text = '5';
    _stimeController.text = '0';
  }

  /// 初始化时钟
  @override
  void dispose() {
    _ctimeController.dispose();
    _mtimeController.dispose();
    _stimeController.dispose();
    _countdown?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF23272e),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimesCard(title: '时钟', textController: _ctimeController),
                TimesCard(title: '分钟', textController: _mtimeController),
                TimesCard(title: '秒钟', textController: _stimeController),
              ],
            ),
            SizedBox(height: 20),
            Text('快给我选', style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                spacing: 10,
                runSpacing: 20,
                children: timePresets.entries
                    .map(
                      (entry) => ChoiceChip(
                        showCheckmark: false,
                        elevation: 0,
                        side: BorderSide(color: Colors.transparent, width: 1),
                        selectedShadowColor: Colors.transparent,
                        selectedColor: Color(0xFF23272e),
                        disabledColor: Colors.deepPurple,
                        label: Text(
                          entry.key,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        selected: true,
                        onSelected: (value) => setState(() {
                          if ((entry.value / 60) == 1) {
                            _stimeController.text = '60';
                            _mtimeController.text = '0';
                            _ctimeController.text = '0';
                          }
                          if ((entry.value / 60) > 1 &&
                              (entry.value / 60) <= 30) {
                            _stimeController.text = '0';
                            _mtimeController.text = (entry.value / 60)
                                .toStringAsFixed(0); //
                            _ctimeController.text = '0';
                          }
                          if ((entry.value / 60) > 30) {
                            _stimeController.text = '0';
                            _mtimeController.text = '0';
                            _ctimeController.text = (entry.value / 60 / 60)
                                .toStringAsFixed(0); //
                          }
                          _selecteTime = entry.value;
                          debugPrint(_selecteTime.toString());
                        }),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text("关机")),
                ButtonSegment(value: 1, label: Text("重启")),
                ButtonSegment(value: 2, label: Text("睡眠")),
                ButtonSegment(value: 3, label: Text("锁屏")),
              ],
              selected: {_selecteAction},
              onSelectionChanged: (Set<int> newSet) {
                setState(() {
                  _selecteAction = newSet.first;
                });
              },
              style: ButtonStyle(
                // 背景
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    // 选中背景 高亮蓝
                    return const Color(0xFF2563eb);
                  }
                  // 未选中底色
                  return const Color(0xFF23272e);
                }),
                // 文字颜色
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return const Color(0xFFb8c2cc);
                }),
                // 边框
                side: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const BorderSide(
                      color: Color(0xFF3b82f6),
                      width: 1.2,
                    );
                  }
                  return const BorderSide(color: Color(0xFF444b58), width: 1);
                }),
                // 圆角整体
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // 内边距，控制按钮大小
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                // 水波纹hover颜色
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.white.withOpacity(0.08);
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.white.withOpacity(0.12);
                  }
                  return null;
                }),
                // 去掉阴影
                elevation: WidgetStateProperty.all(0),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2176dd),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                    shadowColor: const Color(0xFF2176dd).withOpacity(0.3),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.white.withValues(alpha: 0.14);
                      }
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white.withValues(alpha: 0.22);
                      }
                      return null;
                    }),
                    elevation: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) return 5;
                      if (states.contains(WidgetState.pressed)) return 2;
                      return 3;
                    }),
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.timer),
                  SizedBox(width: 8),
                  Text(_isStart ? '取消倒计时任务' : '开始倒计时任务'),
                ],
              ),
              onPressed: () async {
                await _executeAction();
              },
            ),
            SizedBox(height: 20),
            Text(
              '距离 ${_selecteAction == 0
                  ? '关机'
                  : _selecteAction == 1
                  ? '重启'
                  : _selecteAction == 2
                  ? '睡眠'
                  : '锁屏'} 还剩',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),
            Text(
              _isStart ? '$_remain' : '00:00:00',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 50,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
