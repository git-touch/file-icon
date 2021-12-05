import 'package:flutter/widgets.dart';
import 'src/data.dart';

typedef CustomBuilder = Widget? Function(String? key, Icon icon);

class FileIcon extends StatelessWidget {
  final String fileName;
  final double? size;

  /// This color will override the color provided from Seti icons
  final Color? color;

  /// Use this widget to render custom widget by checking the key.
  /// It returns recognized file extension as a [key], and [icon] widget which will be rendered.
  /// This can be used to show custom icon when file type is unknown ([key] is null)
  final CustomBuilder? customBuilder;

  FileIcon(String fileName, {this.size, this.color, this.customBuilder}) : this.fileName = fileName.toLowerCase();

  @override
  Widget build(BuildContext context) {
    String? key;

    if (iconSetMap.containsKey(fileName)) {
      key = fileName;
    } else {
      var chunks = fileName.split('.').sublist(1);
      while (chunks.isNotEmpty) {
        var k = '.' + chunks.join();
        if (iconSetMap.containsKey(k)) {
          key = k;
          break;
        }
        chunks = chunks.sublist(1);
      }
    }

    final Icon iconWidget = Icon(
      IconData(
        iconSetMap[key ?? '.txt']!.codePoint,
        fontFamily: 'Seti',
        fontPackage: 'file_icon',
      ),
      color: color ?? Color(iconSetMap[key ?? '.txt']!.color),
      size: size,
    );

    return customBuilder != null ? (customBuilder!(key, iconWidget) ?? iconWidget) : iconWidget;
  }
}
