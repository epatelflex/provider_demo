import 'package:provider_demo/index.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool filled;

  const AppButton({super.key, required this.onPressed, required this.child, this.filled = true});

  @override
  Widget build(BuildContext context) {
    final Color labelColor = filled
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.primary;

    if (filled) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: labelColor,
        ),
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: labelColor,
      ),
      child: child,
    );
  }
}

