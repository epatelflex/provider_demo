import 'package:provider_demo/index.dart';

abstract class _BaseText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const _BaseText(
    this.text, {
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.style,
    super.key,
  });

  TextStyle? baseStyle(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final TextStyle? base = baseStyle(context);
    final TextStyle? merged = base == null
        ? style?.copyWith(color: color)
        : base.merge(style).copyWith(color: color);
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: merged,
    );
  }
}

class AppHeadline extends _BaseText {
  const AppHeadline(
    super.text, {
    super.textAlign,
    super.color,
    super.maxLines,
    super.overflow,
    super.style,
    super.key,
  });

  @override
  TextStyle? baseStyle(BuildContext context) => Theme.of(context).textTheme.headlineMedium;
}

class AppTitle extends _BaseText {
  const AppTitle(
    super.text, {
    super.textAlign,
    super.color,
    super.maxLines,
    super.overflow,
    super.style,
    super.key,
  });

  @override
  TextStyle? baseStyle(BuildContext context) => Theme.of(context).textTheme.titleMedium;
}

class AppBody extends _BaseText {
  const AppBody(
    super.text, {
    super.textAlign,
    super.color,
    super.maxLines,
    super.overflow,
    super.style,
    super.key,
  });

  @override
  TextStyle? baseStyle(BuildContext context) => Theme.of(context).textTheme.bodyLarge;
}

class AppCaption extends _BaseText {
  const AppCaption(
    super.text, {
    super.textAlign,
    super.color,
    super.maxLines,
    super.overflow,
    super.style,
    super.key,
  });

  @override
  TextStyle? baseStyle(BuildContext context) => Theme.of(context).textTheme.labelMedium;
}

