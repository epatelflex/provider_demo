import 'package:provider_demo/index.dart';

class CountText extends StatelessWidget {
  const CountText({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select((CounterNotifier provider) => provider.count);
    return AppHeadline('$count');
  }
}
