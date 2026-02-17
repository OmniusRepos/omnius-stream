// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:duxt_ui/src/components/form/slider.dart' deferred as _slider;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'duxt_ui:slider': ClientLoader(
      (p) => _slider.DSlider(
        label: p['label'] as String?,
        value: p['value'] as double,
        min: p['min'] as double,
        max: p['max'] as double,
        step: p['step'] as double,
        name: p['name'] as String?,
        size: p['size'] as String,
        color: p['color'] as String,
        disabled: p['disabled'] as bool,
        showValue: p['showValue'] as bool,
        hint: p['hint'] as String?,
      ),
      loader: _slider.loadLibrary,
    ),
  },
);
