import 'package:flutter/material.dart';

enum TextColor {
  black,
  white,
}

extension TextColorExtension on TextColor {
  Color? get color {
    switch (this) {
      case TextColor.black:
        return Colors.black;
      case TextColor.white:
        return Colors.white;
      default:
        return null;
    }
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final TextColor textColor;
  final TextStyle? Function(TextTheme) getStyle;

  CustomText.titleSmall(this.text,
      {super.key, this.textColor = TextColor.black})
      : getStyle = ((TextTheme theme) => theme.titleSmall);

  CustomText.titleMedium(this.text,
      {super.key, this.textColor = TextColor.black})
      : getStyle = ((TextTheme theme) => theme.titleMedium);

  CustomText.titleLarge(this.text,
      {super.key, this.textColor = TextColor.black})
      : getStyle = ((TextTheme theme) => theme.titleLarge);

  CustomText.labelSmall(this.text,
      {super.key, this.textColor = TextColor.black})
      : getStyle = ((TextTheme theme) => theme.labelSmall);

  CustomText.labelMedium(this.text,
      {super.key, this.textColor = TextColor.black})
      : getStyle = ((TextTheme theme) => theme.labelMedium);

  CustomText.bodyMedium(this.text,
      {super.key, this.textColor = TextColor.black})
      : getStyle = ((TextTheme theme) => theme.bodyMedium);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: getStyle(Theme.of(context).textTheme)!.merge(
        TextStyle(color: textColor.color),
      ),
    );
  }
}
