import 'package:provider_demo/index.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const AppTitle('Details')),
      body: const Center(child: CountText()),
    );
  }
}
