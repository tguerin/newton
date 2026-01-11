import 'package:chipmunk2d_physics_ffi/chipmunk2d_physics_ffi.dart' as chipmunk2d_physics_ffi;
import 'package:flutter/widgets.dart';

bool _isInitialized = false;
Future<void>? _initializationFuture;

/// Initializes the Newton particle system.
///
/// **On Web**: This function must be called before using any physics-based particle effects
/// (i.e., before creating any `PhysicsEffectConfiguration` instances).
///
/// **On Other Platforms**: This function is a no-op and can be safely called or omitted.
/// The underlying Chipmunk2D library handles platform detection internally.
///
/// It's recommended to call this in your app's `main()` function for cross-platform compatibility:
/// ```dart
/// import 'package:newton_particles/newton_particles.dart';
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await initializeNewton();
///   runApp(MyApp());
/// }
/// ```
///
/// The initialization is performed only once, even if called multiple times.
/// Subsequent calls will return the same future.
///
/// **Note**: This initialization is only required on web if you're using
/// `PhysicsEffectConfiguration`. If you're only using `DeterministicEffectConfiguration`,
/// you can skip this step.
Future<void> initializeNewton() async {
  if (_isInitialized) {
    return;
  }
  WidgetsFlutterBinding.ensureInitialized();
  _initializationFuture ??= chipmunk2d_physics_ffi.initializeChipmunk();
  await _initializationFuture;
  _isInitialized = true;
}

/// Checks if Newton has been initialized.
///
/// This is primarily used internally to ensure proper initialization.
/// On non-web platforms, this will always return true after the first call to [initializeNewton].
bool get isNewtonInitialized => _isInitialized;
