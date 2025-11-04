import 'package:provider_demo/index.dart';

class CounterNotifier extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int count, {bool notify = true}) {
    _count = count;
    if (notify) {
      notifyListeners();
    }
  }

  void increment() {
    _count += 1;
    notifyListeners();
  }
}
