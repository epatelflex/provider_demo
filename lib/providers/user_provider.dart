import 'package:provider_demo/index.dart';

class UserProvider extends AsyncNotifier with AsyncLoadingMixin<List<User>> {
  final UserService _service = UserService();

  /// Convenience getter for accessing loaded users
  List<User>? get users => data;

  Future<void> loadUsers() async {
    await loadData(() => _service.getUsers());
  }
}
