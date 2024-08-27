import 'package:flutter/cupertino.dart';
import 'package:newton_particles/newton_particles.dart';

/// Abstract class representing a particle effect, defining the behavior of
/// particles and managing their lifecycle within the effect.
abstract class Effect<Particle extends AnimatedParticle, Configuration extends EffectConfiguration> {
  /// Constructor for creating an `Effect` with the specified configurations.
  ///
  /// - [effectConfiguration]: Configuration for the effect itself.
  Effect(this.effectConfiguration);

  static const _noSize = Size(-1, -1);

  /// A flag indicating whether the effect was added at runtime.
  bool addedAtRuntime = false;

  /// List of active particles currently managed by this effect.
  List<Particle> get activeParticles => _activeParticles.toList();

  /// The configuration settings for the effect.
  final Configuration effectConfiguration;

  /// The root effect from which this effect may be derived.
  Effect<AnimatedParticle, EffectConfiguration>? rootEffect;

  /// The current state of the effect (e.g., running, stopped, killed).
  EffectState get state => _state;

  /// The callback invoked when the state of the effect changes.
  void Function(Effect<Particle, Configuration>, EffectState)? _stateChangeCallback;

  /// The size of the surface where the effect is rendered.
  Size get surfaceSize => _surfaceSize;

  /// Sets the size of the surface where the effect is rendered.
  set surfaceSize(Size value) {
    if (_surfaceSize == value) return;
    for (final particle in _activeParticles) {
      particle.onSurfaceSizeChanged(_surfaceSize, value);
    }
    _surfaceSize = value;
    onSurfaceSizeChanged();
  }

  /// The total duration the effect has been running.
  Duration get totalElapsed => _totalElapsed;

  /// Callback triggered after the effect is completed.
  ValueChanged<Effect<AnimatedParticle, EffectConfiguration>>? postEffectCallback;

  /// Sets the state change callback and immediately invokes it with the current state.
  // ignore: avoid_setters_without_getters
  set stateChangeCallback(void Function(Effect<Particle, EffectConfiguration>, EffectState)? value) {
    _stateChangeCallback = value;
    _stateChangeCallback?.call(this, _state);
  }

  final List<Particle> _activeParticles = List.empty(growable: true);
  bool _firstEmission = true;
  Duration _lastInstantiation = Duration.zero;
  EffectState _state = EffectState.running;
  Size _surfaceSize = _noSize;
  int _totalEmittedCount = 0;
  Duration _totalElapsed = Duration.zero;

  /// Advances the effect by the given duration, updating the state and particles.
  void forward(Duration elapsedDuration) {
    // No size available, we can’t render particles
    if(_surfaceSize == _noSize) return;
    _totalElapsed += elapsedDuration;
    if (_totalElapsed < effectConfiguration.startDelay) {
      _lastInstantiation = _totalElapsed;
      return;
    }
    onTimeForwarded(elapsedDuration);
    _emitParticles();
    _cleanParticles();
    _updateParticles();
    _killEffectWhenOver();
  }

  /// Initializes and returns a new particle for the effect.
  Particle instantiateParticle(Size surfaceSize);

  /// Starts the effect, changing its state to running.
  void start() {
    if (_state == EffectState.killed) {
      throw StateError('Can’t start a killed effect');
    }
    _updateState(EffectState.running);
  }

  /// Stops the effect, with an option to cancel and clear all particles.
  void stop({bool cancel = false}) {
    if (_state == EffectState.killed) return;
    _firstEmission = true;
    _updateState(EffectState.stopped);
    if (cancel) {
      _activeParticles.clear();
    }
  }

  /// Immediately stops the effect and clears all particles, marking it as killed.
  void kill() {
    stop(cancel: true);
    _updateState(EffectState.killed);
    postEffectCallback = null;
  }

  /// Invoked when a particle's animation is over.
  ///
  /// Can be overridden in subclasses to handle additional cleanup or logic.
  @protected
  void onParticleDestroyed(Particle particle) {
    // Default implementation does nothing. Override in subclasses if needed.
  }

  @protected
  void onSurfaceSizeChanged() {
    // Default implementation does nothing. Override in subclasses if needed.
  }

  /// Invoked when the effect's time is forwarded, allowing subclasses to react to time changes.
  @protected
  void onTimeForwarded(Duration elapsedDuration) {
    // Default implementation does nothing. Override in subclasses if needed.
  }

  /// Cleans up particles whose animation has ended.
  void _cleanParticles() {
    _activeParticles.removeWhere((activeParticle) {
      final animationOver = activeParticle.animationDuration < totalElapsed - activeParticle.elapsedTimeOnStart;
      if (animationOver) {
        onParticleDestroyed(activeParticle);
        final postEffectBuilder = activeParticle.particle.configuration.postEffectBuilder;
        if (postEffectBuilder != null) {
          postEffectCallback?.call(
            postEffectBuilder(activeParticle.particle, this).effect()
              ..rootEffect = rootEffect
              ..addedAtRuntime = addedAtRuntime,
          );
        }
      }
      return animationOver;
    });
  }

  /// Emits new particles according to the emission configuration.
  void _emitParticles() {
    if (_firstEmission || (totalElapsed - _lastInstantiation > effectConfiguration.emitDuration)) {
      _lastInstantiation = totalElapsed;
      if (_state == EffectState.running) {
        _firstEmission = false;
        for (var i = 0; i < effectConfiguration.particlesPerEmit; i++) {
          if (_isEmissionAllowed()) {
            _totalEmittedCount++;
            final particle = instantiateParticle(_surfaceSize)..onParticleCreated();
            _activeParticles.add(particle);
          } else {
            break;
          }
        }
      }
    }
  }

  /// Checks whether particle emission is allowed based on the effect's configuration.
  bool _isEmissionAllowed() {
    return _totalEmittedCount < effectConfiguration.particleCount || effectConfiguration.particleCount <= 0;
  }

  /// Checks whether the emission is over, and if so, stops the effect.
  bool _isEmissionOver() {
    return activeParticles.isEmpty &&
        _totalEmittedCount == effectConfiguration.particleCount &&
        effectConfiguration.particleCount > 0;
  }

  /// Kills the effect if emission is over and all particles are cleared.
  void _killEffectWhenOver() {
    if (_isEmissionOver()) {
      kill();
    }
  }

  /// Updates the state of the effect and notifies the state change callback.
  void _updateState(EffectState state) {
    _state = state;
    _stateChangeCallback?.call(this, _state);
  }

  /// Updates the animation of all active particles.
  void _updateParticles() {
    for (final element in _activeParticles) {
      element.onAnimationUpdate(totalElapsed - element.elapsedTimeOnStart);
    }
  }
}
