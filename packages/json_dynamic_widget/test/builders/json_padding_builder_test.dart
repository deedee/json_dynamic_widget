import 'package:flutter_test/flutter_test.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

void main() {
  test('type', () {
    const type = JsonPaddingBuilder.kType;

    expect(type, 'padding');
    expect(
      JsonWidgetRegistry.instance.getWidgetBuilder(type)({'padding': '16.0'})
          is JsonPaddingBuilder,
      true,
    );
  });
}
