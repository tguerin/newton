## [0.3.0] - 2025-01-XX

### Breaking Changes
- **[Breaking]** Renamed `RelativisticEffect` to `PhysicsEffect` and `RelativisticEffectConfiguration` to `PhysicsEffectConfiguration` for better clarity and understanding. The old names are deprecated and will be removed in a future version.
- **[Breaking]** Revamped configuration API with grouped properties for better organization and type safety:
  - Introduced `PhysicsProperties`, `VisualProperties`, `EmissionProperties`, `DeterministicProperties`, and `LayerProperties` classes
  - Configuration is now more organized and easier to understand
  - See [Migration Guide](https://newton.7omtech.fr/docs/migration) for details on upgrading

### Features
- [Feature] **Widget Collisions**: Introduced `NewtonCollider` widget allowing particles to collide with Flutter widgets. Supports rounded corners, friction, and restitution with accurate physics using Signed Distance Fields (SDF).
- [Feature] **Effect Presets**: Added preset configurations for common effects:
  - `ConfettiPreset` - Celebratory confetti effect
  - `RainPreset` - Realistic rain effect
  - `SnowPreset` - Snowfall effect
  - `ExplosionPreset` - Explosion effect
  - `FountainPreset` - Fountain effect
- [Feature] **Particle Pool**: Introduced `ParticlePool` for reusing particle instances, reducing memory allocations and improving performance.
- [Feature] **Debug Data Stream**: Added `debugDataStream` to `NewtonState` for real-time monitoring of particle effects, active particle counts, and performance metrics.
- [Feature] **Code Generator**: Enhanced configurator with ability to copy generated code for easy integration.

### Performance
- [Performance] Introduced viewport culling to skip rendering particles outside the visible area, significantly improving performance for large particle counts.
- [Performance] Improved particle sorting strategy for more efficient rendering.
- [Performance] Introduced fixture cache in physics engine to avoid unnecessary fixture recreation.
- [Performance] Optimized collider reporting by removing redundant postFrameCallback in NewtonCollider.build() method, reducing unnecessary work on every rebuild.

### Fixes
- [Fix] Added missing setState() call to clearEffects() method to ensure proper widget rebuild.
- [Fix] Fixed colliders stopping to work when configuration properties (delay, particles per emit, etc.) were changed. Colliders now properly re-report their positions after configuration changes.
- [Fix] Colliders are now preserved during temporary coordinate conversion failures that can occur during widget rebuilds.
- [Fix] Improved collider syncing to physics effects, ensuring colliders are properly synchronized when effects are updated or recreated.

### Documentation
- [Docs] Added comprehensive migration guide for upgrading from 0.2.x to 0.3.x.
- [Docs] Added widget collisions documentation with examples and best practices.
- [Docs] Updated presets documentation with new preset system.
- [Docs] Improved overall documentation structure and clarity.

## [0.2.3] - 2025-12-27

- [Chore] Fix lints and upgrade dependencies
- [Fix] Fix foreground property not behaving as expected. Thanks
  @redredninjacat.
- [Feat] Implemented ShapeBuilder and ZIndexBuilder. Thanks @redninjacat.

## [0.2.2] - 2024-09-06

- [Fix] Remove code generation that is not available for now.
- [Fix] Use gif instead of a video.

## [0.2.1] - 2024-09-06

- [Fix] Pub.dev doc site

## [0.2.0] - 2024-09-06

- [Breaking] Support physics based animation. Revamp the way effects are
  configured and added to the Newton widget.
- [Breaking] Replace duration based properties as int by Duration.
- [Breaking] Origin is now relative to the widget size.
- [Performance] No more unnecessary repaints. thanks @VonZen
- [Performance] Images are now properly garbage collected when animations end.

## [0.1.8] - 2024-06-03

### Fix

- [Fix] Fix #24 Fix name collision in NewtonState.removeEffect by @KriseevM

- [Fix] Add missing setState to clearEffects by @jannikhst

## [0.1.7] - 2023-11-12

### Fix

- [Fix] Fix #20 use right size for image shape

## [0.1.6] - 2023-11-05

### Feature

- [Feature] Add support for background and foreground effects
- [Feature] Add/remove effects at runtime

## [0.1.5] - 2023-08-22

### Feature

- [Feature] Add links to repo and issue tracker + version badge.

## [0.1.4] - 2023-08-18

### Feature

- [Feature] Allow to listen to effect state changes.

## [0.1.3] - 2023-08-13

### Fix

- [Fixed] Properly dispose animation ticker.

## [0.1.2] - 2023-08-10

### Fix

- [Fixed] Use raw.github for logo display.

## [0.1.1] - 2023-08-10

### Fix

- [Fixed] Fix logo display on pub.dev.

## [0.1.0] - 2023-08-10

### Fix

- [Fixed] Improve performance drastically by using drawAtlas as much as
  possible.

## [0.0.13] - 2023-08-07

### Feature

- [Feature] Support trailing to achieve a `shooting star` effect.

## [0.0.12] - 2023-08-06

### Fixed

- [Fix] Fix concurrent modification when post effect is triggered.

## [0.0.11] - 2023-08-06

### Feature

- [Feature] Allow to add a post effect to a particle.
- [Feature] Allow a finite number of particles.
- [Feature] Add firework example.

## [0.0.10] - 2023-08-04

### Feature

- [Feature] Allow color configuration for particles.

### Fixed

- [Fix] Ensure repaint won't happen outside of Newton widget.
- [Fix] Improve performance by disabling compositor cache.

## [0.0.9] - 2023-08-02

### Fixed

- [Fix] Center title for effects.

## [0.0.8] - 2023-08-02

### Fixed

- [Fix] Fix display of the logo on pub.dev.

## [0.0.7] - 2023-08-02

### Fixed

- [Fix] Fix display of doc on pub site.

## [0.0.6] - 2023-08-02

### Feature

- [Feature] Doc update with logo and sample gifs.

## [0.0.5] - 2023-08-01

### Feature

- [Feature] Introduce the notion of PathTransformation for particles.
- [Feature] Add a fountain like effect.

## [0.0.4] - 2023-08-01

### Feature

- [Feature] Add dart docs.
- [Feature] Allow to stop/start/kill an effect.

### Fixed

- [Fix] Fix some imports.

## [0.0.3] - 2023-07-31

### Feature

- [Feature] Rework how effects are configured for better configurability.
- [Feature] Allow to configure angle in smoke effect from configurator.
- [Feature] Add pulse effect.

## [0.0.2] - 2023-07-30

### Fixed

- [Fix] Fix documentation.

## [0.0.1] - 2023-07-30

### Added

- [Feature] Initial release of Newton package.
- [Feature] Implemented a highly configurable particle emitter with default
  effects.
