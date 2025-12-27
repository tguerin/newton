/// Preset effect configurations for common particle effects.
///
/// This library provides easy-to-use presets for common particle effects
/// like confetti, rain, snow, explosions, and fountains. These presets
/// provide sensible defaults and can be customized as needed.
///
/// Example usage:
///
/// ```dart
/// import 'package:newton_particles/newton_particles.dart';
///
/// Newton(
///   activeEffects: [
///     ConfettiPreset().toConfiguration(),
///   ],
/// )
/// ```
library;

export 'confetti_preset.dart';
export 'explosion_preset.dart';
export 'fountain_preset.dart';
export 'rain_preset.dart';
export 'snow_preset.dart';
