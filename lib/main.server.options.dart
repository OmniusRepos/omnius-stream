// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:duxt_ui/src/components/form/slider.dart' as _slider;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _slider.DSlider: ClientTarget<_slider.DSlider>(
      'duxt_ui:slider',
      params: __sliderDSlider,
    ),
  },
);

Map<String, Object?> __sliderDSlider(_slider.DSlider c) => {
  'label': c.label,
  'value': c.value,
  'min': c.min,
  'max': c.max,
  'step': c.step,
  'name': c.name,
  'size': c.size,
  'color': c.color,
  'disabled': c.disabled,
  'showValue': c.showValue,
  'hint': c.hint,
};
