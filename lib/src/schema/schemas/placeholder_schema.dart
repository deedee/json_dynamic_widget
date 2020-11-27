import 'package:json_theme/json_theme_schemas.dart';

class PlaceholderSchema {
  static const id =
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_widget/placeholder.json';

  static final schema = {
    r'$schema': 'http://json-schema.org/draft-06/schema#',
    r'$id': '$id',
    r'$comment':
        'https://api.flutter.dev/flutter/widgets/Placeholder-class.html',
    'type': 'object',
    'title': 'PlaceholderBuilder',
    'additionalProperties': false,
    'properties': {
      'color': SchemaHelper.objectSchema(ColorSchema.id),
      'fallbackHeight': SchemaHelper.numberSchema,
      'fallbackWidth': SchemaHelper.numberSchema,
      'strokeWidth': SchemaHelper.numberSchema,
    }
  };
}
