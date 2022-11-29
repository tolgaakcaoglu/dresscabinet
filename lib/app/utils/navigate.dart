import 'package:flutter/material.dart';

class Navigate {
  static route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);
  static delayed(Widget widget) => PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => widget);
  static next(BuildContext context, Widget widget) =>
      Navigator.push(context, route(widget));
  static nextdelay(BuildContext context, Widget widget) =>
      Navigator.push(context, delayed(widget));

  static back(context) => Navigator.pop(context);

  static rnext(BuildContext context, Widget widget) =>
      Navigator.pushAndRemoveUntil(context, route(widget), (route) => false);
}
