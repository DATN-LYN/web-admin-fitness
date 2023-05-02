
import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer({
    this.duration = const Duration(milliseconds: 500),
  });

  final Duration duration;
  Timer? _timer;

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(duration, action);
  }
}
