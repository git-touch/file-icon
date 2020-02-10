# File Icon for Flutter

[![pub](https://img.shields.io/pub/v/file_icon)](https://pub.dev/packages/file_icon)

File Icon for Flutter, port of [Seti UI icons](https://github.com/jesseweed/seti-ui#current-icons).

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FileIcon(
      // File name
      'main.dart',

      // Icon size
      size: 32,
    );
  }
}
```

## License

MIT
