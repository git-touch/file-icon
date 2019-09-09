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

    if (setiMeta['names'].containsKey(fileName)) {
      key = setiMeta['names'][fileName];
    } else {
      var ext = fileName.split('.').last; // FIXME:
      if (setiMeta['extensions'].containsKey(ext)) {
        key = setiMeta['extensions'][ext];
      }
    }

    if (key == null) {
      key = '_default';
    }
    if (light) {
      key = key + '_light';
    }

    var m = iconDefinitions[key];
    return Icon(
      IconData(m.codePoint, fontFamily: 'Seti', fontPackage: 'seti'),
      color: m.color,
      size: size,
    );
  }
}
