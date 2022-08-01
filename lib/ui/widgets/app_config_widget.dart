import 'package:flutter/widgets.dart';
import 'package:qrisku/service/object_box.dart';

class AppConfigWidget extends InheritedWidget {
  final ObjectBox objectBox;

  const AppConfigWidget({
    Key? key,
    required this.objectBox,
    required Widget child,
  }) : super(key: key, child: child);

  static AppConfigWidget? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppConfigWidget>();

  @override
  bool updateShouldNotify(_) => false;
}