import 'package:flutter_test/flutter_test.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

void main() {
  test('type', () {
    const type = JsonHeroBuilder.kType;

    expect(type, 'hero');
    expect(
      JsonWidgetRegistry.instance.getWidgetBuilder(type)({'tag': 'tag'})
          is JsonHeroBuilder,
      true,
    );
  });
}
