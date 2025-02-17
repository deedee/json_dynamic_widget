// ignore: unused_import
import 'package:flutter/gestures.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

part 'json_interactive_viewer_builder.g.dart';

/// Builder that can build an [InteractiveViewer] widget.
@jsonWidget
abstract class _JsonInteractiveViewerBuilder extends JsonWidgetBuilder {
  const _JsonInteractiveViewerBuilder({required super.args});

  @JsonArgDecoder('interactionEndFrictionCoefficient')
  double _decodeInteractionEndFrictionCoefficient({required dynamic value}) =>
      JsonClass.maybeParseDouble(value) ?? 0.0000135;

  @JsonDefaultParam('interactionEndFrictionCoefficient', '0.0000135')
  @override
  InteractiveViewer buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  });
}
