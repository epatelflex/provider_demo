import 'package:provider_demo/index.dart';

class IncrementFab extends StatelessWidget {
  const IncrementFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.read<CounterNotifier>().increment(),
      child: const Icon(Icons.add),
    );
  }
}
