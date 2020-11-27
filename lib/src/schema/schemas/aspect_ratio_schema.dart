import 'package:json_theme/json_theme_schemas.dart';

class AspectRatioSchema {
  static const id =
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_widget/aspect_ratio.json';

  static final schema = {
    r'$schema': 'http://json-schema.org/draft-06/schema#',
    r'$id': '$id',
    r'$comment':
        'https://api.flutter.dev/flutter/widgets/AspectRatio-class.html',
    'type': 'object',
    'title': 'AspectRatioBuilder',
    'additionalProperties': false,
    'required': [
      'aspectRatio',
    ],
    'properties': {
      'aspectRatio': SchemaHelper.numberSchema,
    }
  };
}
