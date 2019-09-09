import 'package:flutter/widgets.dart';
import 'data.dart';

class SetiIcon extends StatelessWidget {
  final String fileName;
  final bool light;
  final double size;

  SetiIcon(String fileName, {this.light = false, this.size})
      : this.fileName = fileName.toLowerCase();

  @override
  Widget build(BuildContext context) {
    String key;

    if (setiNameMap.containsKey(fileName)) {
      key = setiNameMap[fileName];
    } else {
      /// Strictly we should traverse all extensions and call [endsWith] to test file name,
      /// which may causes performance issue
      /// So we just remove first part of split strings instead
      var ext = fileName.split('.').sublist(1).join('.');

      if (setiExtensionMap.containsKey(ext)) {
        key = setiExtensionMap[ext];
      }
    }

    if (key == null) {
      key = '_default';
    }

    final m = iconDefinitions[key];
    // FIXME: default color
    final colorValue = (light ? m.lightColor : m.color) ?? 0xff000000;

    return Icon(
      IconData(m.codePoint, fontFamily: 'Seti', fontPackage: 'seti'),
      color: Color(colorValue),
      size: size,
    );
  }
}
