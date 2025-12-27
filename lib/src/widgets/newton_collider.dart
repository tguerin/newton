import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newton_particles/src/widgets/newton_collision_notification.dart';
import 'package:uuid/uuid.dart';

/// A widget that marks its child as a collision boundary for Newton particles.
///
/// When a widget is wrapped with [NewtonCollider], particles in physics effects
/// will collide with the widget's shape as if it were a solid boundary.
///
/// Example usage:
/// ```dart
/// Newton(
///   effectConfigurations: [physicsEffectConfig],
///   child: Stack(
///     children: [
///       NewtonCollider(
///         borderRadius: BorderRadius.circular(20),
///         child: Container(
///           width: 200,
///           height: 100,
///           decoration: BoxDecoration(
///             borderRadius: BorderRadius.circular(20),
///           ),
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
class NewtonCollider extends StatefulWidget {
  /// Creates a [NewtonCollider] widget.
  ///
  /// - [child]: The widget that will act as a collision boundary.
  /// - [id]: Optional unique identifier for this collider. If not provided, a hash-based ID will be used.
  /// - [borderRadius]: The border radius of the collider. If not provided, will attempt to extract from child's decoration.
  /// - [key]: An optional key for this widget.
  const NewtonCollider({
    required this.child,
    this.id,
    this.borderRadius,
    super.key,
  });

  /// The widget that will act as a collision boundary.
  final Widget child;

  /// Optional unique identifier for this collider.
  final String? id;

  /// The border radius of the collider.
  final BorderRadius? borderRadius;

  @override
  State<NewtonCollider> createState() => _NewtonColliderState();
}

class _NewtonColliderState extends State<NewtonCollider> with WidgetsBindingObserver {
  static const _uuid = Uuid();
  final GlobalKey _key = GlobalKey();
  late final String _internalId;
  Offset? _lastReportedPosition;
  Size? _lastReportedSize;

  @override
  void initState() {
    super.initState();
    // Use widget.id if provided, otherwise generate a stable UUID
    _internalId = widget.id ?? _uuid.v4();
    WidgetsBinding.instance.addObserver(this);
    // Report geometry after the first frame is painted
    WidgetsBinding.instance.addPostFrameCallback((_) => _report());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _report());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-report when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _report());
    }
  }

  @override
  void didChangeMetrics() {
    // Re-report when screen metrics change (orientation, etc.)
    WidgetsBinding.instance.addPostFrameCallback((_) => _report());
  }

  @override
  void didUpdateWidget(NewtonCollider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-report when widget properties change (e.g., borderRadius)
    if (widget.borderRadius != oldWidget.borderRadius || widget.id != oldWidget.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _report());
    }
  }

  void _report({bool isRemoving = false}) {
    if (!mounted) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Skip if size is invalid
    if (size.width <= 0 || size.height <= 0) return;

    // Only report if position or size changed (to avoid unnecessary updates)
    if (!isRemoving && _lastReportedPosition == offset && _lastReportedSize == size) {
      return;
    }

    _lastReportedPosition = offset;
    _lastReportedSize = size;

    // Try to extract borderRadius from decoration if not provided
    final borderRadius = widget.borderRadius ?? _extractBorderRadius(renderBox);

    NewtonCollisionNotification(
      id: _internalId,
      rect: offset & size,
      borderRadius: borderRadius ?? BorderRadius.zero,
      isRemoving: isRemoving,
    ).dispatch(context);
  }

  BorderRadius? _extractBorderRadius(RenderBox renderBox) {
    // Try to find RenderDecoratedBox in the render tree
    RenderObject? current = renderBox;
    var depth = 0;
    const maxDepth = 10;

    while (current != null && depth < maxDepth) {
      depth++;
      if (current is RenderDecoratedBox) {
        final decoration = current.decoration;
        if (decoration is BoxDecoration && decoration.borderRadius != null) {
          final br = decoration.borderRadius!;
          if (br is BorderRadius) {
            return br;
          }
        }
      }
      if (current is RenderProxyBox) {
        current = current.child;
      } else {
        break;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _report(isRemoving: true);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Schedule a position check after this frame
    // This ensures we catch position changes from layout updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkAndReportPosition();
      }
    });

    return Container(
      key: _key,
      child: widget.child,
    );
  }

  /// Checks if the widget position has changed and reports if needed.
  void _checkAndReportPosition() {
    if (!mounted) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Report if position or size changed
    if (_lastReportedPosition != offset || _lastReportedSize != size) {
      _report();
    }
  }
}
