/// Represents the various states an effect can be in during its lifecycle.
///
/// The [EffectState] enum is used to indicate the current state of an effect,
/// such as an animation or a visual effect, allowing developers to manage
/// and respond to changes in the effect's status.
enum EffectState {
  /// Indicates that the effect has been terminated and cannot be resumed.
  killed,

  /// Indicates that the effect is currently running and active.
  running,

  /// Indicates that the effect has been temporarily stopped but can be resumed.
  stopped,
}
